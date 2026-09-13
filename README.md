# Declarative Linux and macOS configuration

This repository manages NixOS and macOS hosts from one flake and one lock file. NixOS owns Linux system configuration, nix-darwin owns macOS system
configuration, and Home Manager provides the shared user environment.

## Architecture

| Concern                            | Owner               | Location                      |
| ---------------------------------- | ------------------- | ----------------------------- |
| Inputs and host outputs            | Nix flake           | `flake.nix`, `flake.lock`     |
| Host identity and module selection | Typed host records  | `hosts/` (schema in `hosts/options.nix`) |
| Linux system and hardware          | NixOS               | `nixos/`                      |
| macOS system preferences           | nix-darwin          | `darwin/`                     |
| Shared user programs and dotfiles  | Home Manager        | `home/`, `dotfiles/`          |
| Platform-specific user behavior    | Home Manager        | `home/linux/`, `home/darwin/` |
| Locally packaged programs          | nixpkgs derivations | `packages/`                   |

All hosts use the same pinned nixpkgs and Home Manager revisions. Home Manager is integrated into each system generation, so a separate
`home-manager switch` is neither required nor expected.

Available configurations:

| Output                | Platform         | User           | Purpose                    |
| --------------------- | ---------------- | -------------- | -------------------------- |
| `amr`                 | `x86_64-linux`   | `amr`          | Physical NixOS workstation |
| `nixbox`              | `x86_64-linux`   | `vagrant`      | Disposable Vagrant test VM |
| `LYNQTECH-W7CDXHWKLG` | `aarch64-darwin` | `amr.metwally` | macOS workstation          |

Review the matching file in `hosts/` before applying a configuration to a different machine. `system.stateVersion` and `home.stateVersion` are
compatibility markers, not package versions; do not routinely change them.

### Typed host records

Each file in `hosts/` (`amr.nix`, `nixbox.nix`, `macos.nix`) is a plain attribute set of values such as `username`, `sshSettings`, and `extraGroups`.
`flake.nix` evaluates every host file against the schema in `hosts/options.nix` via `lib.evalModules` before building any configuration. That schema
declares each field's type, default, and purpose, so:

- A misspelled or unknown field (e.g. `extraGropus`) fails immediately with an error naming the file and the bad option, instead of surfacing later as a
  missing-attribute error deep inside `nixos/`, `darwin/`, or `home/`.
- A value of the wrong shape (a string where a list is expected, and so on) is rejected the same way.
- `hosts/options.nix` is the single place that documents which fields a host record may set, which are required, and what each one is for — read it
  before adding a new field or a new host.

Add a field by declaring it once in `hosts/options.nix`; every host file can then set it and gets the same type checking.

## Daily workflow

The same commands work on Linux and macOS:

```sh
git pull
make check
make build
make apply
```

The Makefile detects the operating system. It defaults to `hostname -s` on Linux and `scutil --get LocalHostName` on macOS. Override the selected output
when needed:

```sh
make HOST=amr apply
make HOST=nixbox build
```

| Command       | Purpose                                                    |
| ------------- | ---------------------------------------------------------- |
| `make format` | Format every tracked Nix file.                             |
| `make check`  | Evaluate all outputs and the selected host derivation.     |
| `make build`  | Build the selected system without activating it.           |
| `make apply`  | Build and activate the system and Home Manager generation. |
| `make update` | Update `flake.lock`, then run all checks.                  |

Flake commands include `?submodules=1` because the Neovim configuration is a pinned Git submodule. See [docs/neovim.md](docs/neovim.md) for its ownership
and update workflow.

## Fresh NixOS installation

Install NixOS first; this repository does not partition disks or install the base operating system. For hardware other than the configured workstation,
generate and review an appropriate hardware module before switching.

Clone the repository with its submodule:

```sh
git clone --recurse-submodules \
  https://github.com/magdyamr542/nixos-config.git ~/nixos-config
cd ~/nixos-config
$EDITOR hosts/amr.nix
```

The physical host expects an external yescrypt password hash:

```sh
sudo install -d -m 0700 /etc/nixos/secrets
password_hash="$(nix shell nixpkgs#mkpasswd -c mkpasswd -m yescrypt)"
printf '%s\n' "$password_hash" |
  sudo tee /etc/nixos/secrets/amr-password-hash >/dev/null
unset password_hash
sudo chown root:root /etc/nixos/secrets/amr-password-hash
sudo chmod 0600 /etc/nixos/secrets/amr-password-hash
```

Then validate, build, and activate:

```sh
./scripts/bootstrap.sh --host amr
```

The Linux bootstrap verifies the operating system, architecture, selected hostname, user, and required password-hash file before switching.

### Testing with nixbox

The included `Vagrantfile` creates an 80 GB disposable VirtualBox VM:

```sh
vagrant up
vagrant ssh
git clone --recurse-submodules \
  https://github.com/magdyamr542/nixos-config.git ~/nixos-config
cd ~/nixos-config
./scripts/bootstrap.sh --host nixbox
```

After a successful switch, test a real reboot from the host:

```sh
exit
vagrant reload
vagrant ssh
```

The nixbox configuration preserves Vagrant's managed login key and does not require the workstation password-hash file.

## Fresh macOS installation

Install Apple's Command Line Tools first if Git is unavailable:

```sh
xcode-select --install
```

Then clone, review the Mac host record, and bootstrap:

```sh
git clone --recurse-submodules \
  https://github.com/magdyamr542/nixos-config.git ~/nixos-config
cd ~/nixos-config
$EDITOR hosts/macos.nix
./scripts/bootstrap.sh
```

The macOS bootstrap verifies the architecture, LocalHostName, and user. It offers the official multi-user Nix installer when Nix is absent, then uses the
pinned nix-darwin input for the first build and activation. Expect explicit administrator prompts. It does not uninstall Homebrew.

If Nix was installed by Determinate Systems, do not use the installer path unchanged: first adapt nix-darwin's Nix management according to the current
Determinate integration guidance.

Homebrew remains available after Nix profiles for tools and applications that have not been migrated. The remaining work is recorded in
[the macOS migration tracker](docs/trackers/macos-nix-migration.md).

## Packages and configuration

Portable program configuration belongs directly under `home/`. Git, Delta, SSH, tmux, and Neovim have one shared definition. Put substantial platform
differences in `home/linux/` or `home/darwin/` rather than filling shared modules with operating-system conditions.

Add Linux user packages to `home/linux/packages.nix` and macOS user packages to `home/darwin/packages.nix`. Use a Home Manager program module when it can
manage both the package and useful configuration. System-wide Linux packages belong in `nixos/modules/packages.nix`; macOS packages needed by every user
belong in `darwin/default.nix`.

Search the pinned package set or run a package temporarily:

```sh
nix search nixpkgs ripgrep
nix shell nixpkgs#imagemagick
nix run nixpkgs#cowsay -- "hello"
```

Prefer native Home Manager options. Keep plain files under `dotfiles/` only when no useful module exists. Managed files are symlinks into the immutable
Nix store, so edit their repository sources and apply a new generation.

## Secrets and SSH keys

Never commit passwords, password hashes, tokens, or private keys. Public SSH keys may be tracked under `dotfiles/ssh/`; private keys must be installed
directly on the target machine with mode `0600`.

The current host records refer to these optional private keys:

- Linux: `~/.ssh/github` and `~/.ssh/gitlab_tu_dortmund`
- macOS: `~/.ssh/lynqtech_github`

Missing private keys do not prevent evaluation or activation. Only the corresponding SSH connection remains unavailable.

## Updating and rollback

Update all pinned inputs together:

```sh
make update
make build
make apply
```

Review and commit the `flake.lock` diff. Moving to another NixOS, Home Manager, or nix-darwin release is a separate deliberate change and should be tested on
each platform.

On NixOS, list generations or switch to the previous one with:

```sh
sudo nixos-rebuild list-generations
sudo nixos-rebuild switch --rollback
```

On macOS:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild --rollback
```

Also revert the source or lock-file change that caused the problem before a later rebuild. Do not manually delete Nix store paths while recovering.

## Repository workflow

```sh
make format
make check
make build

git add <focused-files>
git commit
git push
```

The optional pre-commit hook formats staged Nix files:

```sh
git config core.hooksPath .githooks
```

Commit `flake.lock`. Do not commit `result` links, generated backups, Vagrant
state, or secrets.

## Repository structure

```text
.
├── flake.nix                     shared inputs and output wiring
├── flake.lock                    exact dependency revisions
├── hosts/                        host identity and module selection
├── nixos/                        Linux system and host modules
├── darwin/                       macOS system configuration
├── home/
│   ├── default.nix               shared Home Manager entry point
│   ├── git.nix                   shared Git and Delta configuration
│   ├── tmux.nix                  shared tmux configuration
│   ├── programs/                 shared SSH, Neovim, and Linux-only VS Code
│   ├── linux/                    Linux packages, shell, and desktop
│   └── darwin/                   macOS packages, shell, and GUI apps
├── dotfiles/                     repository-managed plain files
├── packages/                     local package derivations
├── scripts/
│   ├── bootstrap.sh              platform-dispatching entry point
│   ├── bootstrap-linux.sh
│   ├── bootstrap-darwin.sh
│   └── bin/
├── docs/                         guides and migration trackers
├── Makefile                      shared daily workflow
└── Vagrantfile                   disposable nixbox definition
```

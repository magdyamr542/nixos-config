# Declarative Linux workstation with NixOS

## Overview

This repository manages Linux machines as reproducible NixOS configurations:

- **NixOS** owns boot, hardware, users, networking, services, and software
  needed system-wide.
- **nixpkgs** is the pinned package collection used by both the system and the
  configured user.
- **Flakes** declare inputs and outputs in `flake.nix`; `flake.lock` pins exact
  dependency revisions.
- **Home Manager** is integrated into the NixOS generation and owns user
  packages, programs, dotfiles, and desktop preferences.

The ownership boundary is deliberate:

| Concern                                           | Owner               | Location               |
| ------------------------------------------------- | ------------------- | ---------------------- |
| Host identity and architecture                    | Flake host records  | `hosts/`               |
| User, locale, and shared Nix settings             | NixOS entry point   | `nixos/default.nix`    |
| Hardware, boot, and host-only modules             | NixOS host modules  | `nixos/hosts/`         |
| Desktop, networking, security, and virtualization | NixOS modules       | `nixos/modules/`       |
| User packages and program configuration           | Home Manager        | `home/`                |
| Plain files without a useful module               | Home Manager        | `dotfiles/`            |
| Locally packaged programs                         | nixpkgs derivations | `packages/default.nix` |

NixOS and Home Manager are applied together through one system configuration.

## Host configuration

Each file under `hosts/` describes one flake output and points to its NixOS
host module. The available configurations are:

- `amr`: the physical workstation, declared in `hosts/linux.nix`;
- `nixbox`: the disposable VirtualBox test machine, declared in
  `hosts/nixbox.nix`.

Physical and VM hardware settings are deliberately separate. Never apply the
`amr` output to nixbox or the `nixbox` output to the physical machine.

`system.stateVersion` and `home.stateVersion` are compatibility markers, not
package versions. Do not routinely change them during updates or migrations.

## Required secrets

Secrets deliberately live outside the Git checkout and are not copied into the
Nix store. Never commit passwords, password hashes, private keys, or tokens.

### User password

Create a yescrypt password hash for the configured Linux user:

```sh
sudo install -d -m 0700 /etc/nixos/secrets

password_hash="$(nix shell nixpkgs#mkpasswd -c mkpasswd -m yescrypt)"
printf '%s\n' "$password_hash" |
  sudo tee /etc/nixos/secrets/amr-password-hash >/dev/null
unset password_hash

sudo chown root:root /etc/nixos/secrets/amr-password-hash
sudo chmod 0600 /etc/nixos/secrets/amr-password-hash
```

NixOS reads this external file through `hashedPasswordFile` during activation.

### SSH keys (optional)

Install private SSH keys directly into the user's home directory:

```sh
install -d -m 0700 ~/.ssh
install -m 0600 /path/to/github-private-key ~/.ssh/github
install -m 0600 /path/to/gitlab-private-key ~/.ssh/gitlab_tu_dortmund
```

Public keys are tracked under `dotfiles/ssh/`. Private keys are never placed in
the Nix store. Missing private keys do not prevent a build or activation; only
the corresponding SSH connection is unavailable.

## Fresh-machine preparation

This repository configures an existing NixOS installation. It does not
partition disks or install the operating system. Follow the NixOS installation
manual first and ensure the target user exists or can be created by this
configuration.

This repository vendors the Neovim configuration
(`home/programs/nvim-config`) as a git submodule — clone with
`--recurse-submodules` below, or see [docs/neovim.md](docs/neovim.md) if you
already cloned without it. That doc also covers how Neovim's config and
plugins are managed, how to check installed plugin versions, and how to
upgrade them.

For different hardware, replace the committed hardware module with output
generated on the target machine and review its diff carefully:

```sh
sudo nixos-generate-config --show-hardware-config \
  > nixos/hardware-configuration.nix
```

Then, on the physical workstation:

```sh
git clone --recurse-submodules <your-repository-url> ~/nixos-config
cd ~/nixos-config
$EDITOR hosts/linux.nix
# Provision the external secrets described above.
./scripts/bootstrap.sh --host amr
```

### Testing with nixbox

The included `Vagrantfile` creates the supported disposable test machine with
an 80 GB dynamically allocated primary disk. Its shared `/vagrant` folder is
disabled because the repository is cloned directly into the guest:

```sh
vagrant up
vagrant ssh
git clone --recurse-submodules <your-repository-url> ~/nixos-config
cd ~/nixos-config
./scripts/bootstrap.sh --host nixbox
```

The nixbox host leaves Vagrant's managed login key untouched, uses BIOS GRUB on `/dev/sda`,
and enables VirtualBox guest support. It excludes the physical machine's EFI,
disk, and VirtualBox-host configuration. It also reuses the existing `vagrant`
account and therefore requires no external password hash.

After a successful switch, leave the guest and test a real reboot:

```sh
exit
vagrant reload
vagrant ssh
```

The bootstrap script:

1. refuses to run outside Linux and NixOS;
2. maps the detected CPU architecture to its Nix system name;
3. checks the configured hostname, user, and architecture;
4. checks required external files without displaying their contents;
5. validates and builds the complete flake;
6. applies the NixOS and Home Manager generation together.

It must be run as the configured non-root user. Validation is unprivileged;
secret checks and system activation produce explicit `sudo` prompts.

## Applying changes

The normal loop is:

```sh
git pull
# Edit configuration.
make check
make apply                 # defaults to the current short hostname
make HOST=nixbox apply     # explicit selection
```

`make apply` selects the current short hostname by default. `HOST` can override
that selection, for example:

```sh
make HOST=amr apply
```

Home Manager is part of this system generation. A separate
`home-manager switch` is neither required nor expected, and the standalone
`home-manager` command may not be installed in integrated mode.

Use `make build` to build without switching. It creates the usual ignored
`result` link. A new terminal or login session may be needed after changes to
shell paths and environment variables.

## Makefile commands

| Command       | Purpose                                                           |
| ------------- | ----------------------------------------------------------------- |
| `make format` | Format every Git-tracked Nix file.                                |
| `make check`  | Evaluate all outputs and the selected NixOS system derivation.    |
| `make build`  | Build the selected generation without activating it.              |
| `make apply`  | Build and switch the selected system and Home Manager generation. |
| `make update` | Update `flake.lock`, then run the checks.                         |

The formatter intentionally uses `git ls-files`; ignored files and nested
working copies are never formatted accidentally.

## Adding and removing packages

Add normal user tools to `home/packages.nix`:

```nix
home.packages = with pkgs; [
  ripgrep
  kubectl
];
```

Use a Home Manager program module when it also manages useful configuration.
Git, Delta, Neovim, SSH, zsh, tmux, direnv, FZF, and VS Code are managed
this way.

Put packages in `nixos/modules/packages.nix` only when they are needed by every
local user or for system administration. Local package derivations belong in
`packages/default.nix`.

After changing packages:

```sh
make check
make apply
```

To find packages in the pinned nixpkgs input:

```sh
nix search nixpkgs ripgrep
```

For temporary tools:

```sh
nix shell nixpkgs#imagemagick
nix run nixpkgs#cowsay -- "hello"
```

## Updating inputs

Update all pinned inputs and validate the result:

```sh
make update
make build
make apply
```

Review and commit the `flake.lock` diff. Moving to another NixOS release is a
separate deliberate change: update the nixpkgs and Home Manager release URLs
together, read their release notes, and do not automatically change state
versions.

Neovim's plugins and its `nvim-config` submodule pointer are updated the same
way; see [docs/neovim.md](docs/neovim.md).

## Dotfiles

Prefer native Home Manager options when a mature module exists. Store only
configuration that benefits from being a plain file under `dotfiles/`.

Examples:

- `dotfiles/zsh/p10k.zsh` is linked as `~/.p10k.zsh`.
- `dotfiles/tmux/` is exposed through XDG paths by `home/tmux.nix`.
- `dotfiles/i3/`, `dotfiles/rofi/`, and the wallpaper are Linux desktop files
  owned by `home/desktop.nix`.
- `dotfiles/ssh/` contains public keys only.

Home Manager symlinks managed files from the immutable Nix store. Edit the
repository source and rebuild instead of editing generated files in `$HOME`.

## Hardware and virtualization

`nixos/hardware-configuration.nix` belongs to the physical machine.
`nixos/hardware-nixbox.nix` belongs to the pinned nixbox image. Shared settings
live under `nixos/modules/`, while host-only imports live under `nixos/hosts/`.

`nixos/modules/virtualbox-guest.nix` currently enables VirtualBox guest
additions and group membership. Keep it imported only while this host needs
guest support. VirtualBox host support and the Vagrant network range are
separate settings in `virtualization.nix`.

## Rolling back

List system generations:

```sh
sudo nixos-rebuild list-generations
```

Switch to the previous generation:

```sh
sudo nixos-rebuild switch --rollback
```

The bootloader also exposes previous generations. For a durable source-level
rollback, revert the bad Git or lock-file change and apply again; otherwise a
later rebuild will recreate it. Do not manually delete store paths while
recovering.

Because Home Manager is integrated, rolling back the NixOS generation also
rolls back its user configuration.

## Repository workflow

```sh
git pull

# Make focused changes.
make format
make check
make build
make apply

git add .
git commit -m "Describe the configuration change"
git push
```

Commit `flake.lock`. Do not commit `result` links, generated backups, private
keys, password hashes, or other secrets.

The optional pre-commit hook formats staged Nix files:

```sh
git config core.hooksPath .githooks
```

## Repository structure

```text
.
├── flake.nix                 # inputs and output wiring
├── flake.lock                # exact dependency revisions
├── hosts/linux.nix           # host and user identity
├── nixos/
│   ├── default.nix           # base NixOS configuration
│   ├── hardware-configuration.nix
│   └── modules/              # focused system modules
├── home/
│   ├── default.nix           # Home Manager entry point
│   ├── packages.nix
│   ├── git.nix
│   ├── shell.nix
│   ├── tmux.nix
│   ├── desktop.nix
│   └── programs/
│       └── nvim-config/       # git submodule: magdyamr542/nvim
├── dotfiles/                 # repository-managed plain files
├── docs/
│   ├── neovim.md             # Neovim config/plugin management details
│   └── trackers/
│       └── linux-structure-migration.md
├── packages/default.nix      # custom package derivations
├── scripts/
│   ├── bootstrap.sh
│   └── bin/
├── Makefile
└── Vagrantfile
```

## Future macOS merge

The Linux and macOS repositories now share the same conceptual boundaries and
Makefile interface. During the eventual merge:

- keep `nixos/` and `darwin/` platform-specific;
- give every machine a distinct file under `hosts/`;
- share portable modules from `home/`;
- keep Linux desktop configuration isolated from macOS GUI configuration;
- use platform conditions only where a genuinely shared module needs them;
- generate one NixOS or nix-darwin configuration per host record.

Do not combine the repositories by blindly choosing one version of similarly
named Home Manager modules. Compare their behavior and merge shared settings
module by module.

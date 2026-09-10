# Declarative macOS with Nix

## Overview

This repository manages one macOS machine as a reproducible Nix configuration:

- **Nix** installs packages and builds configurations without mutating package files in place.
- **nixpkgs** is the pinned package collection used by both system and user configuration.
- **Flakes** declare the inputs and outputs in `flake.nix`; `flake.lock` pins exact input revisions.
- **nix-darwin** applies system-wide macOS configuration, Nix daemon settings, shared packages, and macOS preferences.
- **Home Manager** applies packages and configuration belonging to one user, including Git, zsh, editors, and dotfiles.

The ownership boundary is deliberate:

| Concern | Owner | Location |
| --- | --- | --- |
| Host identity and CPU architecture | Flake host definition | `hosts/default.nix` |
| Nix daemon, macOS defaults, all-user packages | nix-darwin | `darwin/default.nix` |
| Developer CLI packages | Home Manager | `home/packages.nix` |
| Git, shell, editor, terminal configuration | Home Manager modules | `home/*.nix`, `home/programs/` |
| Plain files without a module | Home Manager | `dotfiles/` and `home/default.nix` |

Only `vim` is currently system-wide. The normal developer tool set is user-scoped. Homebrew is not enabled and is not required for this configuration.

## Before the first run

Edit `hosts/default.nix`. It is the single source of truth for:

```nix
{
  username = "your-macos-short-name"; # id -un
  hostname = "Your-Mac";              # scutil --get LocalHostName
  system = "aarch64-darwin";          # Apple Silicon
  fullName = "Your Name";
  email = "you@example.com";
}
```

Use `x86_64-darwin` on an Intel Mac. Set `fullName` or `email` to `""` if Git identity should remain unmanaged. The starter values match the Mac on which this repository was generated; review the work email before publishing the repository.

The Home Manager and nix-darwin state versions are compatibility markers, not package versions. Do not routinely change them during updates.

## Fresh Mac installation

Install Apple's Command Line Tools first if `git` is not available:

```bash
xcode-select --install
```

After that dialog completes:

```bash
git clone <your-repository-url> ~/nix-macos
cd ~/nix-macos
$EDITOR hosts/default.nix
./scripts/bootstrap.sh
```

The script:

1. refuses to run outside macOS;
2. maps `arm64` or `x86_64` to the matching Nix system;
3. checks the selected user and architecture;
4. uses the official multi-user Nix installer if Nix is absent;
5. enables flakes for bootstrap commands;
6. validates the flake;
7. runs the pinned nix-darwin activation.

The Nix installer explains its system changes and asks for confirmation. Nix installation and nix-darwin activation require administrator access, so expect explicit `sudo` prompts. The script does not delete existing files or uninstall Homebrew. Home Manager moves a colliding managed file to a sibling ending in `.hm-backup`; if that backup already exists, activation stops safely for manual review.

This setup uses the upstream, multi-user Nix installer because it integrates directly with the Nix daemon configuration owned by nix-darwin. If Nix was already installed by Determinate Systems, do not apply this configuration unchanged: their supported integration requires nix-darwin's built-in Nix management to be disabled. Follow the current Determinate/nix-darwin guidance first.

## Applying changes

The normal loop is:

```bash
git pull
# edit configuration
make check
make apply
```

`make apply` reads the hostname from the flake and runs the equivalent of:

```bash
sudo darwin-rebuild switch --flake .#<hostname>
```

Use `make build` to build without switching. A new terminal may be needed after changes to shell paths or environment variables.

## Adding and removing packages

Add user tools to `home/packages.nix`:

```nix
home.packages = with pkgs; [
  ripgrep
  kubectl
];
```

Then apply them:

```bash
make check
make apply
```

To remove a package, delete its line and rebuild. The old store data may remain until Nix garbage collection, but the package leaves the active user environment immediately.

Prefer a Home Manager program module when it also manages useful configuration. For example, Git, Neovim, tmux, direnv, SSH, zsh, and Starship are enabled in modules rather than listed in `home.packages`. Put a package in `darwin/default.nix` only when every local user needs it.

### Finding packages

Search from the pinned nixpkgs input:

```bash
nix search nixpkgs ripgrep
nix search nixpkgs kubectl
```

The web package search at <https://search.nixos.org/packages> is convenient, but confirm the attribute with `nix search` because this repository follows a pinned revision.

### Temporary packages

Open a shell containing a tool without installing it permanently:

```bash
nix shell nixpkgs#imagemagick
```

Run a package's main executable once:

```bash
nix run nixpkgs#cowsay -- "hello"
```

Use `nix shell` when several commands or an interactive session need the package; use `nix run` for one executable invocation.

## Updating packages

Update all flake inputs and validate the resulting configuration:

```bash
make update
make apply
```

`make update` runs `nix flake update`, changing `flake.lock` to newer revisions on the selected 26.05 release branches. Those aligned branches retain Intel macOS support through the end of 2026; current unstable nixpkgs no longer supports Intel. Review and commit the lock-file diff with the configuration. To update one input only, use `nix flake update nixpkgs` (or `home-manager` / `nix-darwin`), then run `make check` and `make apply`. Moving to a newer release later is a deliberate edit to all three input URLs, followed by review of their release notes and state-version guidance.

## Rolling back

List system generations:

```bash
darwin-rebuild --list-generations
```

If the current generation is usable enough to invoke nix-darwin, switch to the previous one:

```bash
sudo darwin-rebuild rollback
```

For a durable source-level rollback, also revert the bad Git/lock-file change and apply again; otherwise a later rebuild will recreate it. The system profile generations can also be inspected with:

```bash
nix profile history --profile /nix/var/nix/profiles/system
```

Do not manually remove store paths while recovering. If a shell change broke command discovery, open `/bin/zsh` and use `/run/current-system/sw/bin/darwin-rebuild`.

## Dotfiles

### Home Manager-supported program

Add a module under `home/programs/` and import it from `home/programs/default.nix`. For example:

```nix
programs.kitty = {
  enable = true;
  settings.confirm_os_window_close = 0;
};
```

The module installs the program and generates its configuration together.

### One arbitrary file

Store the source in this repository, then add an entry to `home/default.nix`:

```nix
home.file.".tmux.conf".source = ../dotfiles/tmux.conf;
```

The included ripgrep example uses the XDG equivalent:

```nix
xdg.configFile."ripgrep/ripgreprc".source = ../dotfiles/ripgrep/ripgreprc;
```

### An entire configuration directory

For a directory such as `dotfiles/kitty`, use:

```nix
xdg.configFile."kitty" = {
  source = ../dotfiles/kitty;
  recursive = true;
};
```

Home Manager symlinks managed files from the immutable Nix store. Edit the repository source, not the generated file in `$HOME`, and rebuild.

Never commit tokens, credentials, SSH private keys, or other secrets. `programs.ssh` should contain host behavior only. Possible future secret-management choices include sops-nix with age or 1Password integration; choose one only when there is a concrete need.

## Multiple Macs

To add a second Mac without copying shared modules:

1. create `hosts/work-macbook.nix` with the same fields as `hosts/default.nix`;
2. import both host records in `flake.nix`;
3. generate one `darwinConfigurations.<hostname>` entry per record using the existing module list;
4. apply the matching hostname on each Mac.

Shared system behavior remains in `darwin/`, and shared user behavior remains in `home/`. Add a host-specific module to only that host's `modules` list when the machines genuinely differ. The starter intentionally keeps the one-host expression explicit; introduce a small mapping only when the second host exists.

## Optional GUI applications and Homebrew

Prefer nixpkgs for command-line programs and for macOS applications that work well from Nix. Some signed, auto-updating, App Store, or vendor-distributed GUI applications are more practical through another channel. If that need appears later, nix-darwin has an optional `homebrew` module that can declaratively request formulae and casks, but enabling it still requires Homebrew and makes it a secondary compatibility layer. It is intentionally disabled here.

### Migrating safely from Homebrew

Do not uninstall Homebrew during bootstrap. First inventory it:

```bash
brew leaves
brew list --cask
brew services list
brew bundle dump --file=-
```

Replace a few formulae at a time in `home/packages.nix` or with Home Manager program modules. Run `make apply`, start a new shell, and verify binaries with `type -a <command>`. Check services and project toolchains separately before removing their Brew versions. Only after the Nix environment has worked for a while should you consider following Homebrew's official manual uninstall instructions. Keep any casks that are still more reliable through Homebrew.

## Repository workflow

```bash
git pull
make apply

# Make focused changes.
make format
make check
make apply

git add .
git commit -m "Describe the configuration change"
git push
```

Commit `flake.lock`. Do not commit `result` build links, `.DS_Store`, generated backups, or secrets.

## Useful files

```text
.
├── flake.nix                 # pinned inputs and host output wiring
├── flake.lock                # exact dependency revisions
├── hosts/default.nix         # username, hostname, architecture, Git identity
├── darwin/default.nix        # system and conservative macOS settings
├── home/
│   ├── default.nix           # Home Manager entry point and plain dotfile example
│   ├── packages.nix          # user package list
│   ├── git.nix
│   ├── shell.nix
│   └── programs/default.nix
├── dotfiles/ripgrep/ripgreprc
├── dotfiles/nvim/init.lua    # imported legacy Neovim entry point
├── dotfiles/ssh/config       # imported legacy SSH host blocks
├── dotfiles/zsh/zshrc        # imported legacy shell configuration
├── scripts/bootstrap.sh
└── Makefile
```

The Neovim, SSH, and zsh files are temporary migration inputs. Their adjacent
`TODO` comments are intentional: migrate their settings to `programs.neovim`,
`programs.ssh`, `programs.zsh`, and other appropriate Home Manager/Nix modules,
then remove the legacy files. Until then, Oh My Zsh provides autosuggestions
and syntax highlighting, Powerlevel10k provides the prompt, and Home Manager's
duplicate plugin and Starship integrations remain disabled.

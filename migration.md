# Linux configuration structure migration

## Goal

Prepare this Linux NixOS repository for an eventual merge with the macOS
configuration in `nixos-config-macos`. The repositories should use the same
ownership boundaries and workflow where practical:

- host identity in `hosts/`;
- operating-system configuration in `nixos/` or `darwin/`;
- user configuration in `home/`;
- plain configuration files in `dotfiles/`;
- custom packages in `packages/`;
- operational commands exposed through a `Makefile`;
- bootstrap and helper commands in `scripts/`;
- documentation and migration trackers in `docs/`.

The migration should preserve behavior, state versions, and pinned release
branches unless a phase explicitly says otherwise. Package upgrades and major
configuration cleanup should not be mixed with structural moves.

## Current findings

The macOS repository has a clearer separation of responsibilities than the
Linux repository:

- `hosts/default.nix` is the source of host and user identity.
- nix-darwin and Home Manager are applied as one configuration.
- `Makefile` provides `apply`, `build`, `check`, `update`, and `format`.
- Home Manager functionality is split into focused modules.
- Plain files live under a top-level `dotfiles/` directory.
- The README documents installation, daily operation, rollback, and ownership.

The Linux flake currently exposes NixOS and Home Manager as two independently
applied outputs. It also hard-codes the username, hostname, architecture, and
home directory in multiple places.

The initial validation exposed a blocker: `nix flake check --no-build` fails
because `nixos/configuration.nix` reads
`nixos/users/amr/password.txt`, while the README instructs the user to create
`nixos/ignored_files/amr_user_password.txt`. The standalone Home Manager output
does evaluate successfully.

The current password option would also copy a plaintext password into the Nix
store. The blocker must therefore be fixed with a hashed password stored
outside the repository, rather than merely correcting the mismatched path.

## Proposed target structure

```text
.
├── flake.nix
├── flake.lock
├── Makefile
├── README.md
├── migration.md
├── hosts/
│   └── linux.nix
├── nixos/
│   ├── default.nix
│   ├── hardware-configuration.nix
│   └── modules/
│       ├── desktop.nix
│       ├── networking.nix
│       ├── packages.nix
│       ├── security.nix
│       └── virtualization.nix
├── home/
│   ├── default.nix
│   ├── packages.nix
│   ├── git.nix
│   ├── shell.nix
│   ├── tmux.nix
│   ├── gpg.nix
│   ├── desktop.nix
│   └── programs/
│       ├── default.nix
│       ├── neovim.nix
│       └── vscode.nix
├── dotfiles/
│   ├── alacritty/
│   ├── i3/
│   ├── rofi/
│   ├── tmux/
│   └── zsh/
├── packages/
│   └── default.nix
├── scripts/
│   ├── bootstrap.sh
│   └── bin/
└── docs/
    └── trackers/
        └── linux-structure-migration.md
```

Use `hosts/linux.nix` instead of duplicating the macOS
`hosts/default.nix`. When the repositories are combined, distinct host files
will avoid an immediate collision. The macOS host can later be renamed to
`hosts/macos.nix` or to a file based on its hostname.

## Migration phases

### 1. Establish a working baseline

- Replace the plaintext `users.users.amr.password` declaration with
  `hashedPasswordFile` pointing to a root-readable file outside the Git
  checkout.
- Make all other secret references independent of whether untracked files are
  visible to the flake source.
- Remove the need to delete `.git` and `.gitignore` before building.
- Preserve `system.stateVersion = "23.05"` and
  `home.stateVersion = "23.05"`.
- Keep nixpkgs and Home Manager on their current 25.11 branches during the
  structural migration.

Exit criterion: the NixOS flake check and both current configuration evaluations
succeed.

### 2. Introduce a host record

Create `hosts/linux.nix` with the same conceptual fields as the macOS host:

```nix
{
  username = "amr";
  hostname = "amr";
  system = "x86_64-linux";
  fullName = "...";
  email = "...";
}
```

Import it in `flake.nix`, pass `host` through `specialArgs`, and replace
hard-coded instances of the username, hostname, system, and home directory.

### 3. Integrate Home Manager into NixOS

- Add `home-manager.nixosModules.home-manager` to the NixOS module list.
- Configure `home-manager.users.${host.username}` from `home/default.nix`.
- Mirror the macOS choices for `useGlobalPkgs`, `useUserPackages`,
  `backupFileExtension`, and `extraSpecialArgs` where they make sense on Linux.
- Retain the standalone `homeConfigurations` output temporarily as a
  compatibility path.
- Remove that output only after verifying that a single NixOS activation
  applies both system and user configuration correctly.

This establishes one `make apply` workflow and prevents NixOS and Home Manager
generations from drifting apart.

### 4. Restructure NixOS modules

Move `nixos/configuration.nix` to `nixos/default.nix`, then split it by concern:

- Keep boot, locale, user, and base Nix settings in `nixos/default.nix`.
- Move X11, i3, Bluetooth, audio, brightness, and OBS to
  `nixos/modules/desktop.nix`.
- Move NetworkManager, OpenVPN, SSH, and host mappings to
  `nixos/modules/networking.nix`.
- Move Docker and VirtualBox to `nixos/modules/virtualization.nix`.
- Move system packages to `nixos/modules/packages.nix`.
- Move the GPG agent to `nixos/modules/security.nix`.
- Keep the generated hardware configuration separate and avoid hand-editing
  it during the structural migration.
- Preserve `hardware-builder.nix` behavior initially, but rename it according
  to its actual VirtualBox guest role.

File moves and behavioral cleanup should be separate commits.

### 5. Restructure Home Manager

Use the following mapping:

| Current path | Target path |
| --- | --- |
| `home-manager/home.nix` | `home/default.nix` |
| `home-manager/packages.nix` | `home/packages.nix` |
| `home-manager/zsh.nix` | `home/shell.nix` |
| `home-manager/gpg.nix` | `home/gpg.nix` |
| `home-manager/neovim.nix` | `home/programs/neovim.nix` |
| `home-manager/vscode/` | `home/programs/vscode.nix` and supporting data |
| Git dotfile management | Native `home/git.nix` options |
| tmux file declarations | `home/tmux.nix` |
| Linux GUI and i3 declarations | `home/desktop.nix` |

Create `home/programs/default.nix` as an import aggregator. Keep portable
modules such as Git, shell, tmux, and Neovim separate from Linux-only desktop
configuration so they can eventually be shared with macOS.

### 6. Normalize dotfiles and custom packages

- Move `.p10k.zsh` to `dotfiles/zsh/p10k.zsh`.
- Move tmux files to `dotfiles/tmux/`.
- Move Alacritty files to `dotfiles/alacritty/`.
- Move i3, rofi, wallpaper, and related helpers into appropriately named
  directories under `dotfiles/`.
- Translate `.gitconfig` into Home Manager options rather than moving the raw
  file.
- Audit and remove the legacy `.zshrc` if native Home Manager options already
  cover it.
- Move `home-manager/custom-programs/go.nix` to `packages/default.nix` so
  package derivations are not mixed with user configuration modules.

### 7. Add a Makefile

Provide the same public workflow as the macOS repository:

- `make apply`
- `make build`
- `make check`
- `make update`
- `make format`

The Linux implementation should discover the host from
`nixosConfigurations` and invoke `nixos-rebuild`. The format target should use
Git-tracked Nix files rather than recursively searching the working directory;
this prevents an untracked nested checkout such as `nixos-config-macos` from
being modified accidentally.

The existing pre-commit hook may remain, but the Makefile should be the
documented interface.

### 8. Replace `sync.sh` with a bootstrap workflow

Once secret paths no longer depend on untracked repository files, remove the
copy-to-`/etc/nixos` workflow and add `scripts/bootstrap.sh` that:

- verifies Linux and the configured architecture;
- verifies the selected host and user;
- checks for required external secret files without printing them;
- runs the flake checks;
- builds before switching;
- applies `nixosConfigurations.<hostname>`.

The README should separately document a fresh NixOS installation and
`nixos-generate-config`. The bootstrap script should not attempt to automate
disk partitioning or installation of the operating system.

### 9. Rewrite the README

Model the new README after the macOS repository, with Linux-specific sections
for:

- architecture and ownership overview;
- host configuration;
- fresh NixOS installation;
- applying, building, checking, formatting, and updating;
- system versus user package ownership;
- dotfile conventions;
- secret locations and provisioning;
- hardware configuration;
- rollback through NixOS generations;
- normal repository workflow;
- the useful-files tree;
- future multi-host and macOS merge work.

Remove the instruction to delete Git metadata.

### 10. Validate in small commits

Use this commit sequence:

1. Fix secret paths and restore a green baseline.
2. Add host metadata without changing behavior.
3. Integrate Home Manager into NixOS.
4. Move NixOS modules.
5. Move Home Manager modules and dotfiles.
6. Add the Makefile and bootstrap script.
7. Rewrite the README and add a detailed progress tracker.
8. Remove the compatibility output and `sync.sh`.

At each stage, run:

```sh
make format
make check
make build
```

Run `make apply` only after reviewing the build and ensuring a previous NixOS
generation remains available for rollback.

## Merge-readiness principle

The important preparation is not making every filename identical. It is giving
both repositories the same stable ownership model: host records, OS-specific
system modules, portable Home Manager modules, repository-managed dotfiles,
and one consistent Makefile interface.

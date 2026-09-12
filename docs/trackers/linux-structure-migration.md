# Linux migration and combined-repository plan

## Status

The Linux repository migration to the standard layout is complete. The macOS
history and configuration are now being consolidated on `merge-migration`.
This file records the resulting architecture and the remaining validation
before the former repositories can be treated as one stable configuration.

Validated on 2026-09-12:

- `make check` evaluates both `nixosConfigurations.amr` and
  `nixosConfigurations.nixbox`;
- the Neovim configuration submodule is initialized at its pinned revision;
- `vagrant validate` accepts the repository `Vagrantfile`;
- the Git worktree was clean before this tracker update.

## Current architecture

The configuration flows through one integrated system generation:

```text
flake.nix
├── hosts/*.nix                    identity and platform module selection
├── nixos/                         NixOS system and host modules
├── darwin/                        nix-darwin system configuration
└── home/default.nix               shared Home Manager entry point
    ├── home/*.nix                 portable user concerns
    ├── home/programs/*.nix        shared program modules
    ├── home/linux/                Linux-only user concerns
    ├── home/darwin/               macOS-only user concerns
    ├── dotfiles/                  plain files linked by Home Manager
    └── packages/default.nix       locally packaged software
```

`flake.nix` maps three host records to complete NixOS or nix-darwin
configurations:

| Output | User | Purpose | Host module |
| --- | --- | --- | --- |
| `amr` | `amr` | Physical workstation | `nixos/hosts/linux.nix` |
| `nixbox` | `vagrant` | Disposable VirtualBox validation host | `nixos/hosts/nixbox.nix` |
| `LYNQTECH-W7CDXHWKLG` | `amr.metwally` | macOS workstation | `darwin/default.nix` |

Home Manager is embedded in each NixOS output. There is no independent
`homeConfigurations` workflow, so `nixos-rebuild` applies the system and user
configuration together.

The Makefile selects the current hostname and rebuild command for Linux or
macOS and accepts an explicit `HOST`. Because Neovim is a Git submodule, flake
commands use `?submodules=1`. `scripts/bootstrap.sh` dispatches to a platform
bootstrap that validates the selected hostname, architecture, user, and any
platform requirements before checking, building, and switching the complete
generation.

The nixbox path is intentionally host-specific. Vagrant provides an 80 GB
primary disk, upgrades the base image from NixOS 24.05 to 26.05, and selects a
VMSVGA graphics controller. The NixOS host module uses BIOS GRUB, VirtualBox
guest support, automatic root partition/filesystem growth, and a stable device
path instead of the box instance's changing filesystem UUID. It does not
enable VirtualBox host support or replace Vagrant's managed login key.

## Completed migration work

- [x] Replace the plaintext repository password with an external
  `hashedPasswordFile` for the physical user.
- [x] Centralize identity, architecture, groups, authorized keys, secret
  requirements, and host-module selection under `hosts/`.
- [x] Integrate Home Manager into the NixOS system generation.
- [x] Remove the standalone Home Manager output and workflow.
- [x] Split shared NixOS concerns into focused modules.
- [x] Separate physical and nixbox hardware, boot, and virtualization roles.
- [x] Split Home Manager into focused user and program modules.
- [x] Move plain configuration into `dotfiles/` and local derivations into
  `packages/`.
- [x] Replace `sync.sh` with a validation/build/apply bootstrap workflow.
- [x] Add the shared `make apply`, `build`, `check`, `update`, and `format`
  interface.
- [x] Rewrite the README around ownership, installation, daily operation,
  secrets, nixbox testing, updates, and rollback.
- [x] Remove Gitos-specific keys, GPG material, SSH configuration, and OpenVPN
  support.
- [x] Keep private SSH keys outside Git and make them optional for activation.
- [x] Move Neovim configuration to its own pinned Git submodule and manage
  plugin installation through Home Manager.
- [x] Exercise the fresh-machine path with nixbox and encode the disk, boot,
  initrd, root-mount, and graphics fixes discovered during testing.

## Follow-up cleanup before combining repositories

These items do not invalidate the completed structure, but resolving them will
make the later merge smaller and less ambiguous.

- [x] Give Home Manager sole ownership of per-user SSH client host rules while
  keeping `ssh-agent` service ownership at the NixOS layer. The SSH server
  remains a separate system concern in `nixos/modules/networking.nix`.
- [x] Confirm that the physical workstation intentionally needs both
  `virtualbox-host.nix` and `virtualbox-guest.nix`.
- [x] Update the nixbox hardware comment to name the currently pinned 24.05
  Vagrant base box.
- [x] Remove obsolete `.gitignore` rules for the deleted `home-manager/` and
  `ignored_files` layouts.
- [x] Remove the unused legacy plaintext password file under
  `nixos/ignored_files/` without reading or copying its contents.
- [x] Replace the generic flake description with an accurate description of
  the combined Linux and macOS configuration.
- [x] Move this completed migration tracker from the repository root to
  `docs/trackers/linux-structure-migration.md`.
- [x] Recreate the nixbox from scratch with `vagrant destroy` and `vagrant up`,
  then verify bootstrap, reboot, `vagrant ssh`, Home Manager activation, Docker,
  i3 startup, and rollback without manual repair steps.

## Combined-repository plan

### 1. Align shared input policy

- [x] Upgrade Linux to the 26.05 nixpkgs and Home Manager release used by
  macOS.
- [x] Keep nix-darwin as a Darwin-only input and expose formatters for every
  supported Linux and Darwin architecture.
- [x] Use one shared nixpkgs and Home Manager input so updates are validated
  globally before the lock file advances.

Exit criterion: both repositories evaluate against the intended common
nixpkgs and Home Manager revisions before any source trees are merged.

### 2. Define a common host schema

- [x] Give every host its own clearly named file rather than keeping the macOS
  host in `hosts/default.nix`.
- [x] Standardize the portable fields: `username`, `hostname`, `system`,
  `fullName`, and `email`.
- [x] Keep OS-only fields explicit, such as `nixosModule`, `darwinModule`,
  Linux groups, and password sources.
- [x] Add small constructors such as `mkNixosConfiguration` and
  `mkDarwinConfiguration` instead of forcing both systems through one overly
  generic function.

Exit criterion: one `hosts/` tree can generate all Linux and Darwin outputs
without duplicated identity values.

### 3. Merge the flake entry point

- [x] Export `nixosConfigurations` and `darwinConfigurations` from one flake.
- [x] Preserve integrated Home Manager on both platforms.
- [x] Preserve the macOS `darwin-rebuild` package output needed for first-time
  bootstrap.
- [x] Preserve submodule-aware evaluation while the Neovim configuration
  remains a Git submodule.

Exit criterion: `nix flake check --all-systems` evaluates every host from the
combined checkout.

### 4. Consolidate portable Home Manager modules

- [x] Share Git, Delta, SSH, tmux, Neovim, and program aggregation from one
  Home Manager entry point.
- [x] Keep Linux desktop/i3 declarations and macOS GUI application declarations in
  platform-specific modules.
- [ ] Replace Linux's remaining raw `.zshrc` behavior with the already-audited
  native Home Manager approach where practical.
- [x] Use the same Git submodule and Nix-managed Neovim plugin module on both
  platforms. Mason remains responsible only for the configured LSP servers.
- [x] Keep the substantially different package, desktop/GUI, and shell modules
  in explicit `home/linux/` and `home/darwin/` trees. Use a platform condition
  only for the small Linux-only VS Code import.

Exit criterion: portable user behavior has one source of truth and each
platform-specific module has a clear owner.

### 5. Unify workflows without hiding platform differences

- [x] Make the shared Makefile dispatch `apply` and `build` to `nixos-rebuild` or
  `darwin-rebuild` based on the selected host.
- [x] Keep `check`, `update`, and `format` genuinely shared.
- [x] Provide one platform-dispatching bootstrap script with dedicated
  `bootstrap-linux.sh` and `bootstrap-darwin.sh` implementations behind a
  common documented interface.
- [x] Preserve Linux hostname/user/secret safety checks and macOS first-time Nix
  and nix-darwin installation behavior.

Exit criterion: the same documented commands work predictably on both systems
without weakening either platform's bootstrap checks.

### 6. Merge documentation and history

- [x] Build one README covering the shared architecture and normal workflow, with
  separate Linux, nixbox, and macOS installation sections.
- [x] Move active migration notes under `docs/trackers/` and retain completed
  trackers as historical context until the combined setup has been stable.
- [x] Import the second repository with history preserved, then resolve path
  collisions intentionally instead of copying only its final tree.

### 7. Validate the combined repository

- [x] Run formatting and flake checks for all exposed systems.
- Build every Linux and Darwin host output on a compatible machine or builder.
- Recreate and bootstrap nixbox from an empty VM.
- Apply on the physical Linux workstation and verify rollback.
- Apply on macOS and verify nix-darwin, Home Manager, shell, Git, tmux, Neovim,
  and retained Homebrew behavior.
- Confirm no password, private key, token, mutable runtime state, or
  machine-generated secret is tracked or copied into the Nix store.

## Combined-repository completion criteria

The repositories are ready to become one when:

- every host is produced from one flake and one lock file;
- shared Home Manager behavior has one source of truth;
- Linux, nixbox, and Darwin system concerns remain isolated;
- the Makefile and bootstrap interface are documented and tested;
- fresh bootstrap and rollback work on both operating systems;
- secret ownership is explicit and no secret material is committed;
- the old repositories can be archived without losing required configuration
  or migration history.

# macOS Nix migration tracker

This tracker covers the remaining migration from imported legacy configuration
and Homebrew to native nix-darwin and Home Manager declarations. Migrate in
small batches, run `make check` and `make build`, then apply and test before
removing the previous implementation.

## Repository convergence before the combined migration

Prepare this repository to merge into `nixos-config` without erasing genuine
macOS differences:

- [ ] Rename the generic host file and generate Darwin configurations through
  an explicit host mapping and constructor.
- [ ] Use the same pinned Neovim submodule and Nix-managed plugin module as the
  Linux repository.
- [ ] Align the Makefile and bootstrap interfaces while retaining macOS-specific
  host detection, Nix installation, and nix-darwin activation.
- [ ] Refresh the README and Neovim documentation for the resulting structure
  and workflow.
- [ ] Apply the completed preparation on the Mac and verify nix-darwin, Home
  Manager, SSH, Git, Zsh, tmux, Neovim, and GUI applications.

Keep `darwin/` and `home/gui-apps.nix` platform-specific. Do not change the
nix-darwin or Home Manager state versions merely to match Linux; they are
compatibility markers rather than package versions.

## SSH

- [x] Replace the imported `dotfiles/ssh/config` with
  `programs.ssh.settings`.
- [x] Apply the new generation and verify the effective configuration for
  `github.com` and `turntable.*` before deleting SSH backups.

Verification:

```sh
ssh -G github.com | grep -E 'identityfile|addkeystoagent'
ssh -G turntable.example | grep '^port '
```

Expected values are `~/.ssh/lynqtech_github`, enabled AddKeysToAgent
(`ssh -G` normally prints `true`), and port `22022`.

## Git

- [x] Move the existing `~/.gitconfig` identity, aliases, URL rewrite, merge,
  diff, column, and Delta settings into `home/git.nix`.
- [x] Install and integrate Delta through `programs.delta` instead of relying
  on the Homebrew executable.
- [x] Apply the new generation and verify Git reads the managed
  `~/.config/git/config` (XDG) settings directly before deleting backups.

An earlier draft added a `~/.gitconfig` include shim pointing at the XDG
file, on the assumption that Git ignores XDG config once `~/.gitconfig`
exists. That assumption is wrong: Git reads both files (least to most
specific) when they exist, so the shim made Git parse the same settings
twice (confirmed with `git config --show-origin --get-all interactive.diffFilter`
showing every value from two origins pointing at the same file). Home
Manager's `programs.git` module always targets `$XDG_CONFIG_HOME/git/config`
regardless of `xdg.enable`, and Git 2.53 discovers that path natively, so
the shim was removed and `~/.gitconfig` is no longer managed.

Verification:

```sh
git config --global --show-origin --list
git config --global --get alias.crb
git config --global --get url.git@github.com:enercity.insteadof
git config --global --get merge.conflictstyle
git config --global --get diff.colormoved
git config --global --get delta.features
git config --global --get-all interactive.diffFilter  # must show a single origin
type -a delta
```

## Zsh

- [x] Replace the imported `dotfiles/zsh/zshrc` with native Home Manager
  options.
- [x] Use `../nixos-config/home-manager/zsh.nix` as the starting design for
  `programs.zsh`, Oh My Zsh plugins, Powerlevel10k, and `programs.fzf`.
- [x] Adapt the reference instead of copying Linux-specific commands such as
  `nixos-rebuild`, `home-manager switch`, and `xdg-open`.
- [x] Move aliases, history, completions, environment variables, and key
  bindings into their Home Manager options where available.
- [x] Audit the manually sourced files and runtime managers:
  `.p10k.zsh`, `.aliases.sh`, `.funcs.sh`, `.proot`, NVM, SDKMAN, GVM, pyenv,
  kubectl/Helm completion files, and the Vagrant completion paths. Powerlevel10k
  and shell functions are now repository-managed; the installed language
  version managers remain conditionally initialized for compatibility.
- [x] Enable Home Manager's autosuggestion, syntax-highlighting, history search,
  autojump, FZF, completion, and Oh My Zsh integrations without duplicate
  manual loading.
- [x] Keep Powerlevel10k and leave Starship's Zsh integration disabled so only
  one prompt is active.
- [x] Remove `dotfiles/zsh/zshrc` after testing the native configuration in a
  new login shell.

## Homebrew command-line packages

- [x] Capture `brew leaves` and any project-specific dependencies.
  `brew services list` still needs to be run outside tmux (this session was
  inside tmux, so it was skipped).
- [x] Verify the Nix-managed replacements already present for `bat`, `fd`,
  `git`, `jq`, `neovim`, `tmux`, `tree`, `wget`, and Zsh. `autojump` and
  `git-delta` are also already covered.
- [ ] Migrate remaining formulae in small functional batches: developer tools,
  cloud/Kubernetes tools, database clients, media tools, security tools, and
  language toolchains.
  - [x] Developer tools batch: `gh`, `golangci-lint`, `httpie`, `yq` (as
    `yq-go`), `protobuf`, `rename`, `tldr`.
    `watch` was left on Homebrew: it has no Darwin nixpkgs equivalent
    (upstream `procps` is Linux-only there), and the closest nixpkgs
    alternative (`viddy`) is a different tool with a different name, not a
    like-for-like swap.
- [ ] For every batch, declare the Nix packages first, apply, verify with
  `type -a` and representative commands, and only then uninstall the matching
  Homebrew formulae. When uninstalling, check `brew uninstall`'s autoremove
  output carefully: removing `golangci-lint` also autoremoved the `go`
  formula (its only remaining dependent), which silently took the `go`
  compiler off `PATH` even though `go` itself was not part of that batch.
  It was reinstalled via `brew install go`; treat `go`/language toolchains
  as their own deliberate batch rather than letting them go missing as a
  side effect.
- [ ] Keep Homebrew later than the Nix profiles in `PATH` until the migration is
  complete.
- [ ] Review whether any required Homebrew services need an equivalent
  nix-darwin service or should remain managed by Homebrew.

## Neovim

- [ ] Inventory all 22 modules loaded by `init.lua`, including plugins,
  language servers, formatters, and Mason-installed tools.
- [x] Choose a native approach: mirror `../nixos-config/home-manager/neovim.nix`
  and fetch the config from its own GitHub repo
  (`magdyamr542/nvim`, pinned via `pkgs.fetchFromGitHub`) with
  `xdg.configFile.nvim`, instead of committing a local copy of `init.lua`
  into this repo. Plugins stay packer/Mason-managed, same as on the
  reference Linux config; only `packer-nvim` itself needs to be declared
  via `programs.neovim.plugins` so `packadd packer.nvim` works.
- [x] Migrate `home/programs/default.nix` to the fetched config and remove
  `dotfiles/nvim/init.lua`. Verified the fetched `init.lua` at the pinned
  commit is byte-identical to the previously imported copy.
- [ ] Apply the new generation and confirm Neovim starts, packer bootstraps,
  and Mason-installed LSPs still work before considering this done.

## GUI applications and cleanup

- [x] Review Homebrew casks individually and migrate the ones with a working
  nixpkgs equivalent: `1password`, `1password-cli`, `claude-code@latest`,
  `dbeaver-community`, `drawio`, `font-hack-nerd-font`, `hashicorp-vagrant`,
  `insomnia`, `iterm2`, `keepassxc`, `ngrok`, `visual-studio-code` (now in
  `home/gui-apps.nix`), plus `keycast` migrated to nixpkgs' `keycastr` (a
  different fork of the same idea, confirmed acceptable).
  `_1password-cli`, `_1password-gui`, `claude-code`, `ngrok`, and `vagrant`
  are unfree in nixpkgs; allowlisted individually via
  `nixpkgs.config.allowUnfreePredicate` in `darwin/default.nix` rather than
  flipping `allowUnfree` globally.
- [x] Kept on Homebrew, no nixpkgs equivalent available: `hashicorp-boundary-desktop`
  (nixpkgs only has the `boundary` CLI, not the desktop client),
  `omnissa-horizon-client` (exists in nixpkgs but marked unsupported on
  aarch64-darwin), `iptvnator` and `presentation` (not packaged in nixpkgs
  at all). `rar` is also kept, but note it's already broken on Homebrew's
  side (Homebrew disabled the cask on 2026-09-01 over a Gatekeeper failure)
  independent of this migration.
- [ ] Kept on Homebrew by choice, not investigated further: `zed` (the
  editor) — skip any future attempt to migrate this one.
- [ ] Decide whether retained formulae/casks should be declared through
  nix-darwin's Homebrew module.
- [ ] Correct the README rollback example to `sudo darwin-rebuild --rollback`.
- [ ] After an extended stable period, review old nix-darwin generations and
  `.hm-backup` files. Do not delete rollback points or backups prematurely.

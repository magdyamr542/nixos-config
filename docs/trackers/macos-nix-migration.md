# macOS Nix migration tracker

This tracker covers the remaining migration from imported legacy configuration
and Homebrew to native nix-darwin and Home Manager declarations. Migrate in
small batches, run `make check` and `make build`, then apply and test before
removing the previous implementation.

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

## Zsh

- [ ] Replace the imported `dotfiles/zsh/zshrc` with native Home Manager
  options.
- [ ] Use `../nixos-config/home-manager/zsh.nix` as the starting design for
  `programs.zsh`, Oh My Zsh plugins, Powerlevel10k, and `programs.fzf`.
- [ ] Adapt the reference instead of copying Linux-specific commands such as
  `nixos-rebuild`, `home-manager switch`, and `xdg-open`.
- [ ] Move aliases, history, completions, environment variables, and key
  bindings into their Home Manager options where available.
- [ ] Audit and migrate the manually sourced files and runtime managers:
  `.p10k.zsh`, `.aliases.sh`, `.funcs.sh`, `.proot`, NVM, SDKMAN, GVM, pyenv,
  kubectl/Helm completion files, and the Vagrant completion paths.
- [ ] Enable Home Manager's autosuggestion and syntax-highlighting integrations
  after the duplicate Oh My Zsh/manual loading has been removed.
- [ ] Decide whether to keep Powerlevel10k or switch to the already declared
  Starship prompt; enable only one prompt integration.
- [ ] Remove `dotfiles/zsh/zshrc` only after a new login shell has been tested.

## Homebrew command-line packages

- [ ] Capture `brew leaves`, `brew services list`, and any project-specific
  dependencies. Run the services command outside tmux.
- [ ] Verify the Nix-managed replacements already present for `bat`, `fd`,
  `git`, `jq`, `neovim`, `tmux`, `tree`, `wget`, and Zsh.
- [ ] Migrate remaining formulae in small functional batches: developer tools,
  cloud/Kubernetes tools, database clients, media tools, security tools, and
  language toolchains.
- [ ] For every batch, declare the Nix packages first, apply, verify with
  `type -a` and representative commands, and only then uninstall the matching
  Homebrew formulae.
- [ ] Keep Homebrew later than the Nix profiles in `PATH` until the migration is
  complete.
- [ ] Review whether any required Homebrew services need an equivalent
  nix-darwin service or should remain managed by Homebrew.

## Neovim

- [ ] Inventory all 22 modules loaded by the imported `init.lua`, including
  plugins, language servers, formatters, and Mason-installed tools.
- [ ] Choose a native approach (Home Manager's Neovim module, Nixvim, or a
  deliberately packaged Lua configuration) before changing the live setup.
- [ ] Migrate and test incrementally, then remove `dotfiles/nvim/init.lua` and
  any obsolete Mason/Homebrew dependencies.

## GUI applications and cleanup

- [ ] Review Homebrew casks individually. Keep signed, vendor-updated, App
  Store, or otherwise better-supported GUI applications in Homebrew where that
  is the more reliable distribution channel.
- [ ] Decide whether retained formulae/casks should be declared through
  nix-darwin's Homebrew module.
- [ ] Correct the README rollback example to `sudo darwin-rebuild --rollback`.
- [ ] After an extended stable period, review old nix-darwin generations and
  `.hm-backup` files. Do not delete rollback points or backups prematurely.

# Neovim configuration

Neovim's Lua configuration and its plugin installation are deliberately managed by two different systems:

| Concern                               | Owned by                           | Location                                 |
| ------------------------------------- | ---------------------------------- | ---------------------------------------- |
| Lua config (keymaps, plugin setup, …) | `magdyamr542/nvim` (upstream repo) | `home/programs/nvim-config/` (submodule) |
| Plugin installation and versions      | Home Manager                       | `home/programs/neovim.nix`               |

This split replaced an earlier setup where `packer.nvim` installed plugins by
cloning whatever branch each plugin defaulted to on GitHub. Plugin versions now
move only when the repository's nixpkgs pin moves.

## How config loading works

1. `xdg.configFile.nvim` in `home/programs/neovim.nix` materializes `~/.config/nvim` as a directory of symlinks pointing into the Nix store,
   sourced from the vendored `home/programs/nvim-config` submodule. It's read-only — you edit the submodule checkout, not files under
   `~/.config/nvim`, and changes take a `make apply` to show up.
2. `programs.neovim.enable = true` produces a wrapped `nvim` binary. Its `extraConfig` does `:luafile ~/.config/nvim/init.lua`, which is what actually loads the symlinked config from step 1.
3. `programs.neovim.plugins` is a separate list of plugin derivations. Home
   Manager builds a packdir from them and adds it to Neovim's package path.
   This is independent of `~/.config/nvim`; plugin code never lives there.
4. `nvim-treesitter.withPlugins` builds the selected parsers and matching
   queries with Nix. `:TSInstall` and `:TSUpdate` are not part of the normal
   workflow and must not create a second mutable parser set.

So the Lua files under `lua/plugins.lua` in the nvim-config submodule no
longer install anything; they exist only so the other config modules can keep
assuming plugins are already on the runtimepath.

## Checking installed plugin versions

Every entry in `programs.neovim.plugins` is a normal Nix derivation with a
`pname`/`version`, so list them all with one command:

```sh
nix eval '.?submodules=1#nixosConfigurations.amr.config.home-manager.users.amr.programs.neovim.plugins' \
  --apply 'plugins: builtins.concatStringsSep "\n" (map (p: (p.pname or p.name) + " " + (p.version or "?")) plugins)' \
  --raw
```

Swap `amr` for the host/user you want to inspect (e.g. `nixbox`).

Most versions are dates, not semver — nixpkgs snapshots the upstream commit it packaged and uses that commit's date as the plugin's "version", since most of
these plugins don't tag releases.

Where those versions come from:

- **Most plugins**: pinned transitively through `flake.lock`'s `nixpkgs` input.
  `pkgs.vimPlugins.<name>` is nixpkgs' snapshot of each plugin, so versions move
  only when the repository's nixpkgs input moves.
- **Treesitter**: the plugin, grammar revisions, compiled parsers, and queries
  come from the same nixpkgs snapshot through `nvim-treesitter.withPlugins`.
  Neovim 0.12 provides highlighting, `nvim-treesitter` provides indentation,
  and the built-in `:InspectTree` command replaces the archived playground.

## Upgrading plugins

**Everything sourced from nixpkgs** (the bulk of the list): bump the whole pin at once — there's no way to cherry-pick a single plugin's version this way,
since they all come from one nixpkgs revision.

```sh
make update      # nix flake update + make check
make apply
```

If you need one specific nixpkgs-sourced plugin newer than what the pinned `nixpkgs` has, without bumping everything, override just that plugin's `src`
with `overrideAttrs` in `neovim.nix` instead of waiting for the next `make update`.

## Removing legacy Packer state

Home Manager does not own files created by the former Packer setup. Before
testing this configuration on a machine that used it, move or delete these
paths so Neovim cannot load two plugin and parser generations:

```sh
~/.config/nvim/plugin/packer_compiled.lua
~/.local/share/nvim/site/pack/packer
~/.local/share/nvim/site/parser
~/.local/share/nvim/site/parser-info
```

After applying, `:checkhealth vim.treesitter` should list Nix parsers under
`pack/hm/start/nvim-treesitter-grammars` and no paths under `pack/packer`.

## Pulling in upstream nvim-config changes

To bring in changes made directly to `magdyamr542/nvim`, bump the submodule pointer the same way you'd bump `flake.lock`:

```sh
git -C home/programs/nvim-config pull origin master
git add home/programs/nvim-config
git commit -m "Update nvim-config submodule"
```

## Cloning this repo

Because Neovim's config is a submodule, clone with:

```sh
git clone --recurse-submodules <your-repository-url> ~/nixos-config
```

If you already cloned without that flag:

```sh
git submodule update --init --recursive
```

Every flake reference in `Makefile` and `scripts/bootstrap.sh` passes `?submodules=1` so Nix includes submodule content when evaluating the flake.
Without it, evaluation fails with a `path ... does not exist` error for `home/programs/nvim-config`.

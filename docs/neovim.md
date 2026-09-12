# Neovim configuration

Neovim's Lua configuration and its plugin installation are deliberately managed by two different systems:

| Concern                               | Owned by                           | Location                                 |
| ------------------------------------- | ---------------------------------- | ---------------------------------------- |
| Lua config (keymaps, plugin setup, …) | `magdyamr542/nvim` (upstream repo) | `home/programs/nvim-config/` (submodule) |
| Plugin installation and versions      | Home Manager                       | `home/programs/neovim.nix`               |

This split replaced an earlier setup where `packer.nvim` installed plugins by cloning whatever branch each plugin defaulted to on GitHub. That floated
silently until `nvim-treesitter`'s default branch moved to a new API and broke `nvim-yati` and `playground`, which still depended on the old one. Pinning
plugin installation through nixpkgs instead of packer fixes that class of problem: plugin versions only move when you deliberately update this repo's `nixpkgs` pin.

## How config loading works

1. `xdg.configFile.nvim` in `home/programs/neovim.nix` materializes `~/.config/nvim` as a directory of symlinks pointing into the Nix store,
   sourced from the vendored `home/programs/nvim-config` submodule. It's read-only — you edit the submodule checkout, not files under
   `~/.config/nvim`, and changes take a `make apply` to show up.
2. `programs.neovim.enable = true` produces a wrapped `nvim` binary. Its `extraConfig` does `:luafile ~/.config/nvim/init.lua`, which is what actually loads the symlinked config from step 1.
3. `programs.neovim.plugins` is a separate list of plugin derivations. Home Manager builds a packdir (`pack/myNeovimPackages/start/<plugin>`) out of
   them and bakes it into the same wrapped `nvim` binary's runtimepath. This is independent of `~/.config/nvim` — plugin code never lives there.

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
- **`nvim-treesitter` and `playground`**: pinned directly to the compatible
  legacy revisions required by the current Lua configuration. The 26.05
  nixpkgs snapshot archives `playground` and follows a newer treesitter API.
- **`nvim-yati`**: not packaged in nixpkgs, so it is also pinned directly in
  `neovim.nix` with an explicit revision and fixed-output hash.

## Upgrading plugins

**Everything sourced from nixpkgs** (the bulk of the list): bump the whole pin at once — there's no way to cherry-pick a single plugin's version this way,
since they all come from one nixpkgs revision.

```sh
make update      # nix flake update + make check
make apply
```

**Directly pinned plugins** (`nvim-treesitter`, `playground`, and `nvim-yati`)
must be updated by editing their revision and hash in `home/programs/neovim.nix`.
For example:

```sh
git ls-remote https://github.com/yioneko/nvim-yati HEAD   # get the latest commit
```

Then update `rev` in `neovim.nix`'s `nvim-yati` derivation, set `hash = lib.fakeHash;` temporarily, run `make build`, and Nix's hash-mismatch
error will print the correct hash to paste in.

If you need one specific nixpkgs-sourced plugin newer than what the pinned `nixpkgs` has, without bumping everything, override just that plugin's `src`
with `overrideAttrs` in `neovim.nix` instead of waiting for the next `make update`.

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

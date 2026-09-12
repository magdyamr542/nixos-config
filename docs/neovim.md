# Neovim configuration

Neovim configuration and plugin installation have separate owners:

| Concern | Owner | Location |
| --- | --- | --- |
| Lua configuration | `magdyamr542/nvim` | `home/programs/nvim-config/` |
| Plugins and supporting tools | Home Manager | `home/programs/neovim.nix` |

The Lua configuration is pinned as a Git submodule at the same revision used by
the Linux repository. Home Manager links it to `~/.config/nvim` and provides a
wrapped Neovim with the declared plugins on its runtime path. Packer and Mason
do not install plugins or tools at runtime.

The Lua configuration still depends on the legacy `nvim-treesitter` API and
the archived `playground` extension. The 26.05 nixpkgs snapshot no longer
provides that compatible combination, so `home/programs/neovim.nix` pins the
same revisions currently used by Linux. These direct pins can disappear after
the Lua configuration is migrated to the newer treesitter API.

## Updating plugins

Most plugin versions come from the pinned nixpkgs input and move when running:

```sh
make update
make apply
```

`nvim-yati` is pinned directly in `home/programs/neovim.nix`. Update its `rev`
and fixed-output hash together when deliberately upgrading it.

## Updating the configuration

Pull and commit a new submodule revision explicitly:

```sh
git -C home/programs/nvim-config pull origin master
git add home/programs/nvim-config
git commit -m "Update Neovim configuration"
```

## Cloning the repository

Clone with submodules enabled:

```sh
git clone --recurse-submodules <your-repository-url> ~/nix-macos
```

For an existing clone:

```sh
git submodule update --init --recursive
```

The Makefile and bootstrap script use `?submodules=1` so Nix includes the
submodule content in the flake source.

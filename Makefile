.PHONY: apply build check update format

HOST = $$(nix eval --raw '.?submodules=1\#darwinConfigurations' --apply 'configs: builtins.head (builtins.attrNames configs)')

apply:
	sudo darwin-rebuild switch --flake '.?submodules=1#'$(HOST)

build:
	darwin-rebuild build --flake '.?submodules=1#'$(HOST)

check:
	nix flake check '.?submodules=1' --all-systems
	nix eval --raw '.?submodules=1#'darwinConfigurations.$(HOST).config.system.build.toplevel.drvPath

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt $$(find . -name '*.nix' -not -path './.git/*')

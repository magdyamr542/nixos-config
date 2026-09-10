.PHONY: apply build check update format

HOST = $$(nix eval --raw .\#darwinConfigurations --apply 'configs: builtins.head (builtins.attrNames configs)')

apply:
	sudo darwin-rebuild switch --flake .\#$(HOST)

build:
	darwin-rebuild build --flake .\#$(HOST)

check:
	nix flake check --all-systems
	nix eval --raw .\#darwinConfigurations.$(HOST).config.system.build.toplevel.drvPath

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt $$(find . -name '*.nix' -not -path './.git/*')

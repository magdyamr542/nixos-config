.PHONY: apply build check update format

HOST = $$(nix eval --raw .\#nixosConfigurations --apply 'configs: builtins.head (builtins.attrNames configs)')

apply:
	sudo nixos-rebuild switch --flake .\#$(HOST)

build:
	nixos-rebuild build --flake .\#$(HOST)

check:
	nix flake check --all-systems
	nix eval --raw .\#nixosConfigurations.$(HOST).config.system.build.toplevel.drvPath

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt -- $$(git ls-files '*.nix' | while read -r file; do test ! -f "$$file" || printf '%s\n' "$$file"; done)

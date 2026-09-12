.PHONY: apply build check update format

HOST ?= $(shell hostname -s)

apply:
	sudo nixos-rebuild switch --flake '.?submodules=1#'$(HOST)

build:
	nixos-rebuild build --flake '.?submodules=1#'$(HOST)

check:
	nix flake check '.?submodules=1' --all-systems
	nix eval --raw '.?submodules=1#'nixosConfigurations.$(HOST).config.system.build.toplevel.drvPath

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt -- $$(git ls-files '*.nix' | while read -r file; do test ! -f "$$file" || printf '%s\n' "$$file"; done)

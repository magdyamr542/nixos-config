.PHONY: apply build check update format

HOST ?= $(shell scutil --get LocalHostName)
FLAKE_REF := .?submodules=1

apply:
	sudo darwin-rebuild switch --flake '$(FLAKE_REF)#$(HOST)'

build:
	darwin-rebuild build --flake '$(FLAKE_REF)#$(HOST)'

check:
	nix flake check '$(FLAKE_REF)' --all-systems
	nix eval --raw '$(FLAKE_REF)#darwinConfigurations.$(HOST).config.system.build.toplevel.drvPath'

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt -- $$(git ls-files '*.nix' | while read -r file; do test ! -f "$$file" || printf '%s\n' "$$file"; done)

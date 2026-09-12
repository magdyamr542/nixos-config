.PHONY: apply build check update format

UNAME_S := $(shell uname -s)
FLAKE_REF := .?submodules=1

ifeq ($(UNAME_S),Darwin)
HOST ?= $(shell scutil --get LocalHostName)
CONFIGURATION := darwinConfigurations
REBUILD := darwin-rebuild
else
HOST ?= $(shell hostname -s)
CONFIGURATION := nixosConfigurations
REBUILD := nixos-rebuild
endif

apply:
	sudo $(REBUILD) switch --flake '$(FLAKE_REF)#$(HOST)'

build:
	$(REBUILD) build --flake '$(FLAKE_REF)#$(HOST)'

check:
	nix flake check '$(FLAKE_REF)' --all-systems
	nix eval --raw '$(FLAKE_REF)#$(CONFIGURATION).$(HOST).config.system.build.toplevel.drvPath'

update:
	nix flake update
	$(MAKE) check

format:
	nix fmt -- $$(git ls-files '*.nix' | while read -r file; do test ! -f "$$file" || printf '%s\n' "$$file"; done)

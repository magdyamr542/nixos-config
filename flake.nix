{
  description = "NixOS and nix-darwin configuration for Linux and macOS hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Evaluate each host record against hosts/options.nix so a missing or
      # misspelled field, or a value of the wrong shape, fails here with a
      # precise error instead of surfacing later inside nixos/, darwin/, or
      # home/.
      mkHost =
        hostFile:
        (nixpkgs.lib.evalModules {
          modules = [
            ./hosts/options.nix
            hostFile
          ];
        }).config;
      nixosHosts = {
        amr = mkHost ./hosts/amr.nix;
        nixbox = mkHost ./hosts/nixbox.nix;
      };
      macosHost = mkHost ./hosts/macos.nix;
      darwinHosts = {
        ${macosHost.hostname} = macosHost;
      };
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      forDarwinSystems = nixpkgs.lib.genAttrs darwinSystems;
      mkNixosConfiguration =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host inputs outputs; };
          modules = [
            ./nixos
            host.nixosModule
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            { home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ]; }
          ];
        };
      mkDarwinConfiguration =
        host:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit host inputs outputs; };
          modules = [
            host.darwinModule
            home-manager.darwinModules.home-manager
            { home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ]; }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs (_: mkNixosConfiguration) nixosHosts;
      darwinConfigurations = nixpkgs.lib.mapAttrs (_: mkDarwinConfiguration) darwinHosts;

      packages = forDarwinSystems (system: {
        darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
        default = nix-darwin.packages.${system}.darwin-rebuild;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}

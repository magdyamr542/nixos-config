{
  description = "NixOS and nix-darwin configuration for Linux and macOS hosts";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      nixosHosts = {
        amr = import ./hosts/amr.nix;
        nixbox = import ./hosts/nixbox.nix;
      };
      macosHost = import ./hosts/macos.nix;
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
            home-manager.nixosModules.home-manager
          ];
        };
      mkDarwinConfiguration =
        host:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit host inputs outputs; };
          modules = [
            host.darwinModule
            home-manager.darwinModules.home-manager
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

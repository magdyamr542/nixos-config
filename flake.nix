{
  description = "Reproducible macOS configuration with nix-darwin and Home Manager";

  inputs = {
    # The 26.05 release still supports both Apple Silicon and Intel macOS.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      host = import ./hosts/macos.nix;
      hosts = {
        ${host.hostname} = host;
      };
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mkDarwinConfiguration =
        currentHost:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            host = currentHost;
            outputs = self;
          };
          modules = [
            ./darwin
            home-manager.darwinModules.home-manager
          ];
        };
    in
    {
      darwinConfigurations = nixpkgs.lib.mapAttrs (_: mkDarwinConfiguration) hosts;

      # Exposing this package lets bootstrap use the nix-darwin revision pinned
      # by this flake before darwin-rebuild has been installed globally.
      packages = forAllSystems (system: {
        darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
        default = nix-darwin.packages.${system}.darwin-rebuild;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}

{
  description = "My nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      hosts = {
        amr = import ./hosts/linux.nix;
        nixbox = import ./hosts/nixbox.nix;
      };
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
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs (_: mkNixosConfiguration) hosts;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

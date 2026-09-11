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
      host = import ./hosts/linux.nix;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        ${host.hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit host inputs outputs; };
          # > Our main nixos configuration file <
          modules = [
            ./nixos
            home-manager.nixosModules.home-manager
          ];
        };
      };

      formatter.${host.system} = nixpkgs.legacyPackages.${host.system}.nixfmt-rfc-style;
    };
}

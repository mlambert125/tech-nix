{
  description = "Nix flake for creating a Dolbey Tech/Dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }:
    let system = "x86_64-linux";
  in {
    nixosConfigurations = {
      dolbey = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  ./configuration.nix
	  home-manager.nixosModules.default
        ];
        specialArgs = inputs;
      };
    };
  };
}

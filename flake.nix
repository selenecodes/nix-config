{
  description = "Zenful system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    catppuccin.url = "github:catppuccin/nix/e7927025113dc858afa3fc4cbbfbfca453f59dcc";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager, ... }:
  let
    mkDarwinSystem = { hostname, system ? "aarch64-darwin" }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit self inputs; isDarwin = true; };
        modules = [
          ./modules/options.nix
          ./modules/system
          ./modules/packages
          ./hosts/darwin/${hostname}/default.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
        ];
      };
  in {
    darwinConfigurations = {
      studio    = mkDarwinSystem { hostname = "mac-studio"; };
      rwslaptop = mkDarwinSystem { hostname = "work-laptop"; };
    };

    nixosConfigurations = {
      gayming = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self inputs; isDarwin = false; };
        modules = [
          ./modules/options.nix
          ./modules/system
          ./modules/packages
          home-manager.nixosModules.home-manager
          ./hosts/nixos/gayming/default.nix
        ];
      };
    };
  };
}

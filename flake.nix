{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, ... }: {
    darwinConfigurations = {
      studio = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./hosts/darwin/mac-studio/default.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
        ];
      };

      rwslaptop = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./hosts/darwin/work-laptop/default.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
        ];
      };
    };
  };
}

{
  description = "Zenful system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree = {
      url = "github:vic/import-tree";
      flake = false;
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-dots.url = "github:caelestia-dots/caelestia";
    caelestia-dots.flake = false;
    sweet-theme.url = "github:EliverLara/Sweet/nova";
    sweet-theme.flake = false;
    catppuccin.url = "github:catppuccin/nix/e7927025113dc858afa3fc4cbbfbfca453f59dcc";
    bifrost.url = "github:maximhq/bifrost?ref=transports/v1.6.10";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [(import inputs.import-tree ./modules)];
      _module.args.lib = inputs.nixpkgs.lib;
    };
}

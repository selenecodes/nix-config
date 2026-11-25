_: let
  topology = import ../../../lib/ai/topology.nix;
  shared = {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    nixpkgs.config.allowUnfree = true;
  };
in {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = shared;
      };
      darwin = {
        targets = ["*"];
        module = shared;
      };
      homeManager = {
        targets = ["*"];
        module = {
          programs.mcp = {
            enable = true;
            servers.bifrost.url = topology.bifrost.mcpUrl;
          };
        };
      };
    }
  ];
}

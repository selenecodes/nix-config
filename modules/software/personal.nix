let
  personalConfig = {pkgs, ...}: {
    environment.systemPackages = [pkgs.claude-code];
  };
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["gayming"];
          module = personalConfig;
        };
        darwin = {
          targets = ["studio"];
          module = personalConfig;
        };
      }
    ];
  }

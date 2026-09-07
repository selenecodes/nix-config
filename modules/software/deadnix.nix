let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.deadnix];};
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["*"];
          module = packageModule;
        };
        darwin = {
          targets = ["*"];
          module = packageModule;
        };
      }
    ];
  }

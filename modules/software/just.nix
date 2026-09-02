let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.just];};
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

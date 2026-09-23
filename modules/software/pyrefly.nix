let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.pyrefly];};
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

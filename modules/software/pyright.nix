let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.pyright];};
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

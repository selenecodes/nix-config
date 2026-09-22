let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.kind];};
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["gayming"];
          module = packageModule;
        };
        darwin = {
          targets = ["studio"];
          module = packageModule;
        };
      }
    ];
  }

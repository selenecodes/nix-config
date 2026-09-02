let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.slack];};
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["rwslaptop"];
          module = packageModule;
        };
        darwin = {
          targets = ["studio"];
          module = packageModule;
        };
      }
    ];
  }

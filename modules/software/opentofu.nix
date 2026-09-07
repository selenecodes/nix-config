let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.opentofu];};
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

let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.kubernetes-helm];};
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

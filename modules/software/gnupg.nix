let
  packageModule = {pkgs, ...}: {environment.systemPackages = [pkgs.gnupg];};
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

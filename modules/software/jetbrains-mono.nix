let
  fontModule = {pkgs, ...}: {fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];};
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["*"];
          module = fontModule;
        };
        darwin = {
          targets = ["*"];
          module = fontModule;
        };
      }
    ];
  }

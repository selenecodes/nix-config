let
  packageModule = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kubectl
      kubectx
      kubernetes-helm
      kind
      tilt
    ];
  };
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["gayming" "rwslaptop"];
          module = packageModule;
        };
        darwin = {
          targets = ["studio"];
          module = packageModule;
        };
      }
    ];
  }

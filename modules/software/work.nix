_: {
  repository.features = [
    {
      nixos = {
        targets = ["rwslaptop"];
        module = {pkgs, ...}: {
          environment.systemPackages = with pkgs; [
            libpq
            opentofu
            slack
            kubernetes-helm
          ];
        };
      };

      darwin = {
        targets = ["studio"];
        module = {pkgs, ...}: {
          environment.systemPackages = with pkgs; [
            libpq
            opentofu
            slack
            kubernetes-helm
          ];
        };
      };
    }
  ];
}

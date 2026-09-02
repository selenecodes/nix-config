_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming" "rwslaptop"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.usbutils];
        };
      };
    }
  ];
}

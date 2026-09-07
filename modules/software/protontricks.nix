_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
        module = {pkgs, ...}: {environment.systemPackages = [pkgs.protontricks];};
      };
    }
  ];
}

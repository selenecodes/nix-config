_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
        module = _: {
          services.tailscale.enable = true;
        };
      };
    }
  ];
}

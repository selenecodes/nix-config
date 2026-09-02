_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
        module = {pkgs, ...}: {
          services.ananicy = {
            enable = true;
            package = pkgs.ananicy-cpp;
            rulesProvider = pkgs.ananicy-rules-cachyos;
          };
        };
      };
    }
  ];
}

_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          virtualisation = {
            docker = {
              autoPrune.enable = true;
              enableOnBoot = true;
            };

            oci-containers.backend = "docker";
          };
        };
      };
    }
  ];
}

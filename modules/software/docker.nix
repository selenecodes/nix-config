_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          virtualisation = {
            docker = {
              enable = true;
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

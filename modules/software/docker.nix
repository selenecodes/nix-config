_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          virtualisation = {
            docker = {
              enable = true;
              autoPrune.enable = true;
              enableOnBoot = true;
            };

            oci-containers.backend = "docker";
          };

          systemd.services.docker.path = [pkgs.nftables];
        };
      };
    }
  ];
}

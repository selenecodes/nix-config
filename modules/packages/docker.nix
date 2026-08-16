_: {
  nixos.base = {
    virtualisation = {
      docker = {
        autoPrune.enable = true;
        enable = true;
        enableOnBoot = true;
      };

      oci-containers.backend = "docker";
    };
  };
}

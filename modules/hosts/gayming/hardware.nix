# CPU and firmware for gayming
_: {
  nixos.configurations.gayming.module = {
    config,
    lib,
    ...
  }: {
    hardware = {
      # Swap for intel.updateMicrocode if using Intel
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      graphics.enable32Bit = true;
      nvidia = {
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "610.43.02";
          sha256_64bit = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
          sha256_aarch64 = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
          openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
          settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
          persistencedSha256 = "sha256:0nd0bf2s9b2ic8a0rcscddasddkryx2qf6mx4861bv44wblm513z";
        };
      };
    };

    # 75% power limit (RTX 5090 TDP = 575W -> 431W)
    # systemd.services.nvidia-power-limit = {
    #   enable = false;
    #   description = "NVIDIA GPU 75% power limit";
    #   wantedBy = ["multi-user.target"];
    #   after = ["nvidia-persistenced.service"];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #     ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 431";
    #   };
    # };
  };
}

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
          version = "610.57.04";
          sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
          sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
          openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
          settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
          persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
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

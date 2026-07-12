# NVIDIA RTX 5090 (Blackwell / GB202)
_: {
  nixos.nvidia = {config, ...}: {
    boot = {
      # Required for NVIDIA Wayland + KMS
      kernelParams = ["quiet" "splash" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1"];
      initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      # Open kernel modules are mandatory for Blackwell
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Required for Steam/Wine/Proton
    };

    services.xserver.videoDrivers = ["nvidia"];

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # 75% power limit (RTX 5090 TDP = 575W → 431W)
    systemd.services.nvidia-power-limit = {
      description = "NVIDIA GPU 75% power limit";
      wantedBy = ["multi-user.target"];
      after = ["nvidia-persistenced.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 431";
      };
    };
  };
}

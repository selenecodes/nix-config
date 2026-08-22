# NVIDIA RTX 5090 (Blackwell / GB202)
_: {
  nixos.nvidia = {config, ...}: {
    nix.settings = {
      substituters = [
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };

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
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "610.43.02";
        sha256_64bit = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
        sha256_aarch64 = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
        openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
        settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
        persistencedSha256 = "sha256:0nd0bf2s9b2ic8a0rcscddasddkryx2qf6mx4861bv44wblm513z";
      };
    };

    hardware.nvidia-container-toolkit.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Required for Steam/Wine/Proton
    };

    services.xserver.videoDrivers = ["nvidia"];

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # 75% power limit (RTX 5090 TDP = 575W → 431W)
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

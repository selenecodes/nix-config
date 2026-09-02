_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          nix.settings = {
            substituters = ["https://cache.nixos-cuda.org"];
            trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
          };

          boot = {
            kernelParams = ["nvidia_drm.modeset=1" "nvidia_drm.fbdev=1"];
            initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
          };

          hardware = {
            nvidia = {
              modesetting.enable = true;
              nvidiaSettings = true;
            };
            nvidia-container-toolkit.enable = true;
            graphics.enable = true;
          };

          services.xserver.videoDrivers = ["nvidia"];

          environment.sessionVariables = {
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            # __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
            LIBVA_DRIVER_NAME = "nvidia";
          };
        };
      };
    }
  ];
}

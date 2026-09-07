_: {
  nixos.configurations.rwslaptop.module = {config, ...}: {
    hardware.nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}

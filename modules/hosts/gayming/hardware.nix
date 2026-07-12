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
    };
  };
}

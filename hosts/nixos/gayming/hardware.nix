# NVIDIA RTX 5090 (Blackwell / GB202) + CachyOS kernel
{ config, pkgs, lib, ... }:

{
  # Zen kernel — performance-oriented, in nixpkgs, good fit for gaming/desktop
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Required for NVIDIA Wayland + KMS
  boot.kernelParams = [ "quiet" "splash" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # NVIDIA RTX 5090 — open kernel modules are mandatory for Blackwell
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # 75% power limit (RTX 5090 TDP = 575W → 431W)
  systemd.services.nvidia-power-limit = {
    description = "NVIDIA GPU 75% power limit";
    wantedBy = [ "multi-user.target" ];
    after = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 431";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for Steam/Wine/Proton
  };

  # CPU — swap for intel.updateMicrocode if using Intel
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # zram compressed swap (reduces disk I/O, good for gaming)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
}

# NVIDIA RTX 5090 (Blackwell / GB202) + CachyOS kernel
{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    # Zen kernel — performance-oriented, in nixpkgs, good fit for gaming/desktop
    kernelPackages = pkgs.linuxPackages_zen;

    # Bootloader
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    # Required for NVIDIA Wayland + KMS
    kernelParams = ["quiet" "splash" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1"];
    initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  hardware = {
    # NVIDIA RTX 5090 — open kernel modules are mandatory for Blackwell
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    graphics = {
      enable = true;
      enable32Bit = true; # Required for Steam/Wine/Proton
    };

    # CPU — swap for intel.updateMicrocode if using Intel
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true; # This handles the Solaar GUI properly
  };

  services.xserver.videoDrivers = ["nvidia"];

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

  # zram compressed swap (reduces disk I/O, good for gaming)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # CPU governor
  powerManagement.cpuFreqGovernor = "performance";

  # Peripherals
}

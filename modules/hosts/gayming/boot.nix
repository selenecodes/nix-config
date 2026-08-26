# Zen kernel + boot + memory config for gayming
_: {
  nixos.configurations.gayming.module = {pkgs, ...}: {
    boot = {
      # Zen kernel — performance-oriented, good fit for gaming/desktop
      kernelPackages = pkgs.linuxPackages_zen;

      loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 5;
        systemd-boot.memtest86.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernel.sysctl = {
        "vm.swappiness" = 10;
      };
    };

    # zram compressed swap (reduces disk I/O, good for gaming)
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };

    powerManagement.cpuFreqGovernor = "performance";
  };
}

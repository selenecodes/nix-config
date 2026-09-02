{
  config,
  inputs,
  ...
}: let
  username = "selene";
in {
  nixos.configurations.gayming.module = {
    pkgs,
    pkgsStable,
    ...
  }: {
    imports = [
      config.nixos.base
      config.nixos.audio
      config.nixos.bluetooth
      config.nixos.networking
      config.nixos.nvidia
      config.nixos.desktop
      config.nixos.gaming
      config.nixos.wayland
      config.nixos.personal
      inputs.home-manager.nixosModules.home-manager
    ];

    myConfig.user.name = username;

    networking = {
      hostName = "gayming";
      networkmanager.enable = true;
      nftables.enable = true;
      firewall.enable = true;
    };

    systemd.services.wake-on-lan = {
      description = "Enable wake on LAN";
      wantedBy = ["multi-user.target"];
      after = ["network-pre.target"];
      before = ["network.target"];
      path = [pkgs.ethtool];
      serviceConfig.Type = "oneshot";
      script = ''
        for interface in /sys/class/net/*; do
          interface="''${interface##*/}"
          [ "$interface" = "lo" ] && continue
          ethtool -s "$interface" wol g || true
        done
      '';
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nixpkgs.config.allowUnfree = true;

    users.users.${username} = {
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = ["wheel" "networkmanager" "input" "docker" "audio" "gamemode" "video" "render" "plugdev" "i2c"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7XD47kGwOQQetoxcQOb4TvoqNyNc7LopmaRTkrsxyt7AAtArHIHhX1107tnSfmArgAYf4PPxonoiNfzO5i0HiT11zy9JK1CbrwIWN87zSW1npl9kaQowXMbWC+2OeixTPRIaOh5l6rsUQbuJBZUaHghznXFqtWZpoyhuHub7hOaFahun3ySoAz9gtKz0cuA+g5JxkoqG/mzr+y11iVR1Tn+n0jqRQPPodOehKHYLnQJT5fEvyVHP459qMWgICPPtHl4+YuwO4hBiUpZvHikOeYsDl0cplc8uGHzn95dxs1zfxStCYesdGn7maEFvfREgw8cNOzRh5WGRJJDbkqQiKbPYkD9TjOTNorysJaS3cE4BIeRQFraJRinWRiMvVTsVSXI/XD+CT1WjP/IyYcsNfFbgbsljssVZceMGxmUkE3i9STB8t+RqhXg05JO87bCAofzPlPLskHGBqsM1eS/1QItadXeKS2ttu0agpdo0/i2O1PjEABYnVE/zhvJ/mqjc= seleneblok@Selenes-Mac-Studio.local"
      ];
    };

    hardware.i2c.enable = true;

    security.sudo.wheelNeedsPassword = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit pkgsStable;};
      backupFileExtension = "backup";
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        imports = [
          config.homeManager.base
          config.homeManager.wayland
          config.homeManager.caelestia
        ];
        home = {
          stateVersion = "26.05";
          file.".face".source = ../../../assets/avatars/yachiyo.png;
        };
        myConfig.caelestia.extraHyprlandConfig = ''
          hl.monitor({
            output = "desc:ASUSTek COMPUTER INC ASUS PA279 0x0000C171",
            mode = "3840x2160@59.997",
            position = "0x0",
            scale = 1,
          })
        '';
      };
    };

    system.stateVersion = "25.11";
  };
}

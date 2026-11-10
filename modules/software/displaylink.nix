{
  inputs,
  lib,
  ...
}: let
  # The pinned nixpkgs module still passes evdi, but its package now expects
  # linuxPackages. Keep userspace libevdi paired with the selected kernel.
  displaylinkModule = builtins.toFile "displaylink-kernel-packages.nix" (
    lib.replaceStrings ["inherit evdi;"] ["linuxPackages = config.boot.kernelPackages;"]
    (builtins.readFile "${inputs.nixpkgs}/nixos/modules/hardware/video/displaylink.nix")
  );
in {
  repository.features = [
    {
      nixos = {
        targets = ["rwslaptop"];
        module = {
          config,
          lib,
          pkgs,
          ...
        }: {
          disabledModules = ["hardware/video/displaylink.nix"];
          imports = [displaylinkModule];

          options.myConfig.displaylink.enable = lib.mkEnableOption "DisplayLink";

          config = lib.mkIf config.myConfig.displaylink.enable {
            environment.systemPackages = [
              (pkgs.displaylink.override {linuxPackages = config.boot.kernelPackages;})
            ];
            services.xserver.videoDrivers = ["displaylink" "modesetting"];
            systemd.services.dlm.wantedBy = ["multi-user.target"];
          };
        };
      };
    }
  ];
}

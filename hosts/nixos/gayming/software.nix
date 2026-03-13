# System packages for gayming NixOS host
{ pkgs, ... }: {
  imports = [
    ../../../shared/software/common/default.nix
    ../../../shared/software/common/nixos.nix
    ../../../shared/software/personal/nixos.nix
  ];

  # Udev rules to recognize the YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    claude-code
    # Yubikey
    yubikey-manager         # ykman CLI
    yubioath-flutter        # Authenticator GUI
    yubikey-touch-detector  # Notifies you when a touch is needed
  ];
}

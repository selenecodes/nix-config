# NixOS-specific personal software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    google-chrome
    firefox
    # discord
    # plezy # not in nixos-25.11
  ];
}

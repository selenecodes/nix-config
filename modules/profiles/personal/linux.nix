# NixOS-specific personal software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    google-chrome
    plezy
  ];
}

# System packages for gayming NixOS host
{ pkgs, inputs, ... }: {
  # Host-specific packages
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

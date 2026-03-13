{ pkgs, lib, inputs, ... }: {
  home.stateVersion = "25.11";
  imports = [
    ./home/default.nix
  ];
}

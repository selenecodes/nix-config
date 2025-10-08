{ pkgs, lib, ... }: {
  home.stateVersion = "25.11";
  imports = [
    ../shared/home/default.nix
    ./home/default.nix
  ];
}

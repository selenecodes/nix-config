# Personal software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    netbird
    discord
  ];
}

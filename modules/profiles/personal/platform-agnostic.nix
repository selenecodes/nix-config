# Personal software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    claude-code
    netbird
  ];
}

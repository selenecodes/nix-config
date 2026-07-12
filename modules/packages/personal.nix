_: {
  nixos.personal = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      claude-code
      google-chrome
      firefox
    ];
  };
  darwin.personal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.claude-code];
  };
}

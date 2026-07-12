{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.myconfig.isPersonal {
  environment.systemPackages = with pkgs;
    [
      claude-code
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      google-chrome
      firefox
    ];
}

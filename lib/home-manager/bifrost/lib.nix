_: {
  mkConfig = pkgs: settings: let
    jsonFormat = pkgs.formats.json {};
  in
    jsonFormat.generate "bifrost-config.json" settings;

  mkArgs = cfg:
    [
      "-host"
      cfg.host
      "-port"
      (toString cfg.port)
      "-app-dir"
      (toString cfg.appDir)
      "-log-level"
      cfg.logLevel
      "-log-style"
      cfg.logStyle
    ]
    ++ cfg.extraArgs;
}

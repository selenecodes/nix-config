{ isDarwin, lib, ... }: {
  imports = [
    ./platform-agnostic.nix
  ] ++ lib.optionals isDarwin [
    ./darwin.nix
  ];

  home-manager.sharedModules = [ ./home ];
}

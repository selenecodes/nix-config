{ isDarwin, lib, ... }: {
  imports = [
    ./platform-agnostic.nix
  ] ++ lib.optionals isDarwin [
    ./darwin.nix
  ] ++ lib.optionals (!isDarwin) [
    ./linux.nix
  ];

  home-manager.sharedModules = [ ./home ];
}

{ isDarwin, lib, ... }: {
  imports = [
    ./platform-agnostic.nix
  ] ++ lib.optionals isDarwin [
    ./darwin.nix
  ] ++ lib.optionals (!isDarwin) [
    ./nixos.nix
  ];

  home-manager.sharedModules = [ ./home ];
}

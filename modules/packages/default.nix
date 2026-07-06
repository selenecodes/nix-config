{ isDarwin, lib, ... }: {
  imports = [
    ./common.nix
    ./personal.nix
    ./work.nix
  ] ++ lib.optionals isDarwin [
    ./darwin-personal.nix
    ./darwin-work.nix
  ];
}

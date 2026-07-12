{
  isDarwin,
  lib,
  ...
}: {
  imports =
    [
      ./common.nix
    ]
    ++ lib.optionals isDarwin [
      ./darwin.nix
    ]
    ++ lib.optionals (!isDarwin) [
      ./nixos.nix
      ./gaming.nix
      ./wayland.nix
      ./nixos-services.nix
    ];
}

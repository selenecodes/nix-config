{lib, ...}: {
  homebrew.brews = lib.mkAfter ["asimov" "gh"];
  homebrew.casks = lib.mkAfter ["signal" "logitech-g-hub"];
}

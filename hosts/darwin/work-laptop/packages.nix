{lib, ...}: {
  homebrew.casks = lib.mkAfter ["displaylink" "microsoft-teams"];
}

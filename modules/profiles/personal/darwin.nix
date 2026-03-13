# Darwin-specific personal software (Homebrew packages)
{ ... }: {
  homebrew.brews = [];

  homebrew.casks = [
    "betterdisplay"
    "bettermouse"
    "cleanshot"
    "raycast"
    "soundsource"
  ];
}

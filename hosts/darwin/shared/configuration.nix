{ inputs, config, pkgs, lib, self, ... }:

{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
    defaults = {
      controlcenter = {
        Sound = false;
        NowPlaying = false;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.5;
        tilesize = 60;
        show-recents = false;
        # Application hide and show effect
        mineffect = "genie";
        launchanim = true;
        # Hover magnification settings
        largesize = 84;
        magnification = true;
        # Whether to make hidden apps translucent
        showhidden = true;
        # Group expose apps by application
        expose-group-apps = true;
        # Hot corners (1 is disabled)
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        ShowRemovableMediaOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        # Search in same folder by default (instead of "this mac")
        FXDefaultSearchScope = "SCcf";
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowStatusBar = true;
      };
      iCal = {
        "TimeZone support enabled" = true;
        CalendarSidebarShown = true;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowSeconds = true;
        ShowDate = 1;
      };
      spaces = {
        # MacOS spaces are configured on a per-monitor basis
        # I would prefer to span accross all monitors but this breaks
        # fullscreen apps (e.g. all screens turn black when entering fullscreen)
        # except for the main screen
        spans-displays = false;
      };
      trackpad = {
        # Enable lookup & data detectors on triple tap
        TrackpadThreeFingerTapGesture = 2;
        TrackpadThreeFingerDrag = true;
        # Medium firmness for clicks (0 is light, 1 is medium, 2 is firm)
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
      };
      loginwindow = {
        GuestEnabled = false;
        PowerOffDisabledWhileLoggedIn = false;
        RestartDisabledWhileLoggedIn = false;
        RestartDisabled = false;
        ShutDownDisabledWhileLoggedIn = false;
        ShutDownDisabled = false;
        SleepDisabled = false;
      };
      ActivityMonitor = {
        IconType = 5;
        ShowCategory = 101;
      };
      WindowManager = {
        EnableTiledWindowMargins = false;
      };
    };
  };

  # Make sure to set networking.knownNetworkServices to the services you want to use.
  # in the hosts/{hostname}/default.nix file.
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
  programs.zsh.enable = true;
}
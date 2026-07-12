{self, ...}: {
  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
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
        mineffect = "genie";
        launchanim = true;
        largesize = 84;
        magnification = true;
        showhidden = true;
        expose-group-apps = true;
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
        # Per-monitor spaces — spanning breaks fullscreen on secondary monitors
        spans-displays = false;
      };
      trackpad = {
        TrackpadThreeFingerTapGesture = 2;
        TrackpadThreeFingerDrag = true;
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

  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = ["--verbose"];
    };
    brews = [
      "gnupg"
      "pinentry-mac"
    ];
    taps = [];
    greedyCasks = true;
    casks = [
      "arc"
      "libreoffice-still"
      "lm-studio"
      "raycast"
    ];
  };
}

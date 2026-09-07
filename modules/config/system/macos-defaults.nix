_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module.system.defaults = {
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
    }
  ];
}

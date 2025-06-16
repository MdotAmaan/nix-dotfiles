{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    plasma.enable = lib.mkEnableOption "Enables plasma";
  };

  config = lib.mkIf config.plasma.enable {
    programs.plasma = {
      enable = true;
      workspace = {
        #iconTheme = "Papirus-Dark";
        #lookAndFeel = "org.kde.breezedark.desktop";
      };

      hotkeys.commands = {
        nix-config = {
          name = "Open nix config";
          comment = "Opens the nix config directory with neovide";
          key = "Meta+Shift+C";
          command = "neovide ~/nix-dotfiles/.";
        };

        hyperhdr = {
          name = "Launch HyperHDR";
          comment = "Launches HyperHDR";
          key = "Meta+Shift+H";
          command = "hyperhdr";
        };
      };

      shortcuts = {
        "ksmserver"."Lock Session" = ["Meta+Shift+L" "Screensaver"];
        "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+S";

        # Desktop Management
        "kwin" = {
          "Overview" = "Meta+Shift+W";
          "view_zoom_in" = ["Meta+Shift++" "Meta+Shift+="];

          "Switch to Next Desktop" = "Meta+.";
          "Switch to Previous Desktop" = "Meta+,";
          "Window to Desktop 1" = "Ctrl+Alt+Shift+a";
          "Window to Desktop 2" = "Ctrl+Alt+Shift+r";
          "Window to Desktop 3" = "Ctrl+Alt+Shift+s";
          "Window to Desktop 4" = "Ctrl+Alt+Shift+t";
          "Window to Desktop 5" = "Ctrl+Alt+Shift+g";
          "Window to Next Desktop" = "Meta+>";
          "Window to Previous Desktop" = "Meta+<";

          "Window Quick Tile Left" = "";
          "Window Quick Tile Right" = "";
          "Window Quick Tile Top" = "";
          "Window Quick Tile Bottom" = "";
          "Edit Tiles" = "Alt+Ctrl+T";

          "Switch Window Down" = "Meta+E";
          "Switch Window Left" = "Meta+N";
          "Switch Window Right" = "Meta+O";
          "Switch Window Up" = "Meta+I";

          # Karousel
          "karousel-window-move-left" = "Meta+Left";
          "karousel-window-move-down" = "Meta+Down";
          "karousel-window-move-up" = "Meta+Up";
          "karousel-window-move-right" = "Meta+Right";
          "karousel-column-width-decrease" = "Meta+[";
          "karousel-column-width-increase" = "Meta+]";
          "karousel-columns-width-equalize" = "Meta+=";

          "karousel-window-toggle-floating" = "Meta+W";
          "karousel-focus-end" = "Meta+/";
          "karousel-focus-start" = "Meta+H";
          "karousel-window-move-start" = "Meta+Home";
          "karousel-window-move-end" = "Meta+End";
        };

        # Application Launchers
        "obsidian.desktop"."_launch" = "Meta+L";
        "floorp.desktop"."_launch" = "Meta+F";
        "services/konsole.desktop"."_launch" = "Meta+T";
        "org.kde.dolphin.desktop"."_launch" = "Meta+X";
        "systemsettings.desktop"."_launch" = ["Tools" "Meta+S"];
        "thunderbird.desktop"."_launch" = "Meta+C";
        "org.kde.plasma.emojier.desktop"."_launch" = "Meta+'";
      };

      configFile = {
        "kwinrc" = {
          "Desktops"."Number"."value" = 6;
          "Windows"."FocusPolicy" = "FocusFollowsMouse";
          "Windows"."NextFocusPrefersMouse" = "true";

          "Script-karousel" = {
            "resizeNeighborColumn" = true;
            "skipSwitcher" = false;
            "gapsInnerHorizontal" = 7;
            "gapsInnerVertical" = 7;
            "gapsOuterBottom" = 7;
            "gapsOuterLeft" = 7;
            "gapsOuterRight" = 7;
            "gapsOuterTop" = 7;
            "manualResizeStep" = 300;

            "windowRules" = ''                       
              [{        
                "class": "Gnuplot",
                "tile": false
              },
              {        
                "class": "ksmserver-logout-greeter",
                "tile": false
              },
              {
                "class": "org.kde.plasmashell",
                "tile": false
              },
              {        
                "class": "org.kde.kded6",
                "tile": false
              },
              {
                "class": "org.kde.kcalc",
                "tile": false
              },
              {
                "class": "org.kde.kfind",
                "tile": true
              },
              {
                "class": "org.kde.kruler",
                "tile": false
              },
              {
                "class": "org.kde.krunner",
                "tile": false
              },
              {
                "class": "org.kde.yakuake",
                "tile": false
              },
              {
                "class": "moe.launcher.the-honkers-railway-launcher",
                "tile": false
              },
              {
                "class": "moe.launcher.an-anime-game-launcher",
                "tile": false
              },
              {
                "class": "io.mrarm.mcpelauncher-ui-qt",
                "tile": false
              },
              {
                "class": "firefox",
                "caption": "Picture-in-Picture",
                "tile": false
              },    
              {
                "class": "org.kde.plasma.emojier",
                "tile": false 
              }]'';
          };
        };

        "kdeglobals"."KDE"."SingleClick" = "false"; # Double click to open
        "kscreenlockerrc"."Daemon"."Timeout" = 20; # Set screen timeout to 20 minutes
      };
    };

    home.packages = with pkgs; [
      kde-rounded-corners
    ];
  };
}

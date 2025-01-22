{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
  };
  home = {
    username = "mdot";
    homeDirectory = "/home/mdot";
    stateVersion = "23.11";

    packages = with pkgs;
      [
        inkscape
        krita
        blender-hip
        # kicad
        freecad
        audacity
        anytype

        kdenlive
        easyeffects
        # Game stuff
        prismlauncher

        # TODO: Remove later and replace with dev shells
        libcxxStdenv
        clang-tools
        clang
        cmake
        libgcc
        android-tools
        zathura
        texliveMedium
        jdk21
        #  python311Packages.west
        hyperhdr
        libreoffice-qt
        nh
        element-desktop
        qbittorrent
        vlc
        # pureref
        kdePackages.partitionmanager
        kdePackages.qtwebsockets
        ungoogled-chromium
        vscodium
        filelight
        lazygit
        logseq
        nextcloud-client
        fastfetch
        obs-studio
        libcap
        unzip
        distrobox
        qtcreator
        yt-dlp
        tmux
        krdc
      ]
      ++ [
        pkgs-unstable.lunarvim
        # pkgs-unstable.alvr
      ];

    sessionVariables = {
      EDITOR = "neovide";
      FLAKE = "/home/mdot/dotfiles/";
    };
  };

  programs = {
    home-manager.enable = true;

    plasma = {
      enable = true;
      kwin = {
        # scripts.krohnkite.enable = true;
      };

      workspace = {
        #iconTheme = "Papirus-Dark";
        #lookAndFeel = "org.kde.breezedark.desktop";
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
          "karousel-window-toggle-floating" = "Meta+W";
          "karousel-focus-end" = "Meta+/";
          "karousel-focus-start" = "Meta+H";
          "karousel-window-move-start" = "Meta+Home";
          "karousel-window-move-end" = "Meta+End";
        };

        # Application Launchers
        "logseq.desktop"."_launch" = "Meta+L";
        "firefox.desktop"."_launch" = "Meta+F";
        "services/org.kde.konsole.desktop"."_launch" = "Meta+T";
        "org.kde.dolphin.desktop"."_launch" = "Meta+X";
        "systemsettings.desktop"."_launch" = ["Tools" "Meta+S"];
        "thunderbird.desktop"."_launch" = "Meta+C";
        "org.kde.plasma.emojier.desktop"."_launch" = "Meta+'";
      };

      configFile = {
        "kwinrc" = {
          "Desktops"."Number"."value" = 5;
          "Windows"."FocusPolicy" = "FocusFollowsMouse";
          "Windows"."NextFocusPrefersMouse" = "true";

          "Script-karousel" = {
            "gapsInnerHorizontal" = 9;
            "gapsInnerVertical" = 9;
            "gapsOuterBottom" = 9;
            "gapsOuterLeft" = 9;
            "gapsOuterRight" = 9;
            "gapsOuterTop" = 9;
            "manualResizeStep" = 300;

            "windowRules" = ''                 
              [{        
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

    neovide = {
      enable = true;
      settings = {
        font.normal = [];
        font.size = 9.0;
      };
    };

    firefox = {
      enable = true;
      policies = {
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        OfferToSaveLogins = false;
        DisableFirefoxScreenshots = true;
        NoDefaultBookmarks = true;
        DNSOverHTTPS = {
          Enabled = true;
        };
      };
      profiles.mdot = {
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = "@np";
                }
              ];
            };
          };
        };
        settings = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.compactmode.show" = true;
        };
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          ublock-origin
          darkreader
        ];
      };
    };

    nvf = {
      enable = true;
      settings = import ../neovim/nvf-configuration.nix;
    };

    git = {
      enable = true;
      userName = "MdotAmaan";
      userEmail = "mdotamaan@protonmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    lf = {
      enable = true;
      commands = {
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };

      keybindings = {
        "\\\"" = "";
        o = "";
        c = "mkdir";
        "." = "set hidden!";
        "`" = "mark-load";
        "\\'" = "mark-load";
        "<enter>" = "open";

        do = "dragon-out";

        "g~" = "cd";
        gh = "cd";
        "g/" = "/";

        ee = "editor-open";
        V = ''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';

        # ...
      };

      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };

      extraConfig = let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi

          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
    };
  };

  # Services
  services.syncthing.enable = true;

  systemd.user.startServices = "sd-switch";
}

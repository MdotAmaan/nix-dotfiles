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
        kdenlive
        easyeffects
        # Game stuff
        alvr
        prismlauncher

        # TODO: Remove later and replace with dev shells
        libcxxStdenv
        clang-tools
        clang
        cmake
        libgcc
        android-tools
        neovide
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
        unzip
        distrobox
        qtcreator
        yt-dlp
        tmux
        krdc
      ]
      ++ [
        pkgs-unstable.lunarvim
      ];

    sessionVariables = {
      EDITOR = "lvim";
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
        "kwin"."Overview" = "Meta+Shift+W";
        "kwin"."view_zoom_in" = ["Meta+Shift++" "Meta+Shift+="];
        "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+S";

        # Desktop Management
        "kwin"."Switch to Next Desktop" = "Meta+.";
        "kwin"."Switch to Previous Desktop" = "Meta+,";
        "kwin"."Window to Desktop 1" = "Ctrl+Alt+Shift+a";
        "kwin"."Window to Desktop 2" = "Ctrl+Alt+Shift+r";
        "kwin"."Window to Desktop 3" = "Ctrl+Alt+Shift+s";
        "kwin"."Window to Desktop 4" = "Ctrl+Alt+Shift+t";
        "kwin"."Window to Desktop 5" = "Ctrl+Alt+Shift+g";
        "kwin"."Window to Next Desktop" = "Meta+>";
        "kwin"."Window to Previous Desktop" = "Meta+<";

        "kwin"."Window Quick Tile Left" = "";
        "kwin"."Window Quick Tile Right" = "";
        "kwin"."Window Quick Tile Top" = "";
        "kwin"."Window Quick Tile Bottom" = "";
        "kwin"."Edit Tiles" = "Alt+Ctrl+T";

        "kwin"."Switch Window Down" = "Meta+E";
        "kwin"."Switch Window Left" = "Meta+N";
        "kwin"."Switch Window Right" = "Meta+O";
        "kwin"."Switch Window Up" = "Meta+I";

        # Karousel
        "kwin"."karousel-window-move-left" = "Meta+Left";
        "kwin"."karousel-window-move-down" = "Meta+Down";
        "kwin"."karousel-window-move-up" = "Meta+Up";
        "kwin"."karousel-window-move-right" = "Meta+Right";
        "kwin"."karousel-column-width-decrease" = "Meta+[";
        "kwin"."karousel-column-width-increase" = "Meta+]";
        "kwin"."karousel-window-toggle-floating" = "Meta+W";
        "kwin"."karousel-focus-end" = "Meta+/";
        "kwin"."karousel-focus-start" = "Meta+H";
        "kwin"."karousel-window-move-start" = "Meta+Home";
        "kwin"."karousel-window-move-end" = "Meta+End";

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
        "kwinrc"."Desktops"."Number"."value" = 5;
        "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
        "kwinrc"."Windows"."NextFocusPrefersMouse" = "true";
        "kdeglobals"."KDE"."SingleClick" = "false"; # Double click to open
        "kscreenlockerrc"."Daemon"."Timeout" = 20; # Set screen timeout to 20 minutes
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
    };
  };

  # Services
  services.syncthing.enable = true;

  systemd.user.startServices = "sd-switch";
}

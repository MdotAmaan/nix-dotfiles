{ pkgs, pkgs-unstable,inputs, lib, config, ... }:
{
  nixpkgs = {
    overlays = [
      ./renderdoc.nix
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
       "electron-27.3.11"
      ];
    };
  };

home.username = "mdot";
home.homeDirectory = "/home/mdot";
home.stateVersion = "23.11"; # Please read the comment before changing.
home.packages = with pkgs; [
  # Creative Stuff
    inkscape
    krita
    blender-hip
    # kicad
    freecad
    audacity
    kdenlive
    renderdoc

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

    lunarvim
    zathura
    texliveMedium
    jdk21

    # Keyboard
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

  ] ++ [
    # pkgs-stable.cura 
    # pkgs-unstable.orca-slicer
    # pkgs-unstable.kicad
  ];
  programs.firefox = {
    enable = true;
    policies = {
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      OfferToSaveLogins = false;
      DisableFirefoxScreenshots = true;
      NoDefaultBookmarks = true;
    };
    profiles.mdot = {
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = "@np";
            }];
          };
          "Brave Search" = {
            urls = [{
              template = "https://search.brave.com/search";
              params = [
                { name = "type"; value = "packages"; }
                { name = "q"; value = "{searchTerms}"; }
              ];
              updateInterval = 24 * 60 * 60 * 1000; # every day
            }];
          };
        };
      };
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
         bitwarden 
         ublock-origin 
         darkreader
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "MdotAmaan";
    userEmail = "mdotamaan@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.fish = {
      enable = true;
      shellAbbrs = {
        ls = "ls -f";
        nc = "cd ~/dotfiles/ && lvim .";
      };
      interactiveShellInit = "set -U fish_greeting";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lf = {
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
  programs.plasma = {
    enable = true;
  #  panels = [
  #    {
  #      location = "top";
  #      widgets = [
  #        {
  #          name = "org.kde.plasma.kickoff";
  #          config = {
  #            General.icon = "nix-snowflake";
  #          };
  #        }
  #        "org.kde.plasma.icontasks"
  #        "org.kde.plasma.marginsseparator"
  #        "org.kde.plasma.systemtray"
  #        "org.kde.plasma.digitalclock"
  #      ];
  #    }
  #  ];

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

      # Polonium
      # "kwin"."PoloniumInsertAbove" = "Meta+Up";
      # "kwin"."PoloniumInsertBelow" = "Meta+Down";
      # "kwin"."PoloniumInsertRight" = "Meta+Right";
      # "kwin"."PoloniumInsertLeft" = "Meta+Left";
      # "kwin"."PoloniumRetileWindow" = "Meta+H";

      # Disable Polonium
      "kwin"."PoloniumInsertAbove" = "";
      "kwin"."PoloniumInsertBelow" = "";
      "kwin"."PoloniumInsertRight" = "";
      "kwin"."PoloniumInsertLeft" = "";
      "kwin"."PoloniumRetileWindow" = "";

      # Karousel
      "kwin"."karousel-window-move-left" = "Meta+Left";
      "kwin"."karousel-window-move-down" = "Meta+Down";
      "kwin"."karousel-window-move-up" = "Meta+Up";
      "kwin"."karousel-window-move-right" = "Meta+Right";
      "kwin"."karousel-column-width-decrease" = "Meta+[";
      "kwin"."karousel-column-width-increase" = "Meta+]";
      "kwin"."karousel-window-toggle-floating" = "Meta+W";

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
  
  # Services
  services.syncthing.enable = true;

  systemd.user.startServices = "sd-switch";

  home.file = {
    #".config/nvim/".source = ./nvim;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mdot/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
     FLAKE = "/home/mdot/dotfiles/";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}


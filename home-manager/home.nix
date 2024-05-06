{ pkgs, inputs, lib, config, ... }:
{
  nixpkgs = {
    overlays = [

    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  home.username = "mdot";
  home.homeDirectory = "/home/mdot";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.packages = with pkgs; [
   # Creative Stuff
   #blender-hip
   #inkscape
   #krita
   nh
   git-crypt
   #element-web
   #qbittorrent
   #btop
   #android-tools
   #vlc
   #sunshine
   filelight
   lazygit
   logseq
   #nextcloud-client 
   fastfetch
   # obs-studio
   #syncthingtray
   unzip
  ];

  programs.firefox = {
    enable = true;
    profiles.mdot = {
      search.engines = {
        "Nix Packages" = {
           urls = [{
             template = "https://search.nixos.org/packages";
             params = [
               { name = "type"; value = "packages"; }
               { name = "query"; value = "{searchTerms}"; }
             ];
             definedAliases = [ "@np" ];
           }];
       };
      };
       search.force = true;
       extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
         bitwarden 
         ublock-origin 
         sponsorblock
         youtube-shorts-block
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
      };
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
    panels = [
      {
        location = "top";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake";
            };
          }
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    workspace = {
      #iconTheme = "Papirus-Dark";
      #lookAndFeel = "org.kde.breezedark.desktop";
    };

    shortcuts = {
      "ksmserver"."Lock Session" = ["Meta+Shift+L" "Screensaver"];

      # Desktop Management
      "kwin"."Switch to Next Desktop" = "Meta+PgUp";
      "kwin"."Switch to Previous Desktop" = "Meta+PgDown";
      "kwin"."Window to Desktop 1" = "Ctrl+Alt+Shift+a";
      "kwin"."Window to Desktop 2" = "Ctrl+Alt+Shift+r";
      "kwin"."Window to Desktop 3" = "Ctrl+Alt+Shift+s";
      "kwin"."Window to Desktop 4" = "Ctrl+Alt+Shift+t";

      "kwin"."Switch Window Down" = "Meta+E";
      "kwin"."Switch Window Left" = "Meta+N";
      "kwin"."Switch Window Right" = "Meta+O";
      "kwin"."Switch Window Up" = "Meta+I";

      # Application Launchers
      "logseq.desktop"."_launch" = "Meta+L";
      "org.kde.dolphin.desktop"."_launch" = "Meta+X";
      "systemsettings.desktop"."_launch" = ["Tools" "Meta+S"];
      "thunderbird.desktop"."_launch" = "Meta+C";
    };

    configFile = {
      "kwinrc"."Desktops"."Number"."value" = 5;
    };
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

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
  };
  systemd.user.startServices = "sd-switch";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

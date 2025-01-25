{
  pkgs,
  # pkgs-unstable,
  ...
}: {
  home = {
    username = "mdot";
    homeDirectory = "/home/mdot";
    stateVersion = "23.11";

    packages = with pkgs; [
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
      thunderbird
      hyperhdr
      libreoffice-qt
      element-desktop
      qbittorrent
      vlc
      # pureref
      kdePackages.partitionmanager
      kdePackages.qtwebsockets
      ungoogled-chromium
      filelight
      lazygit
      logseq
      nextcloud-client
      fastfetch
      obs-studio
      libcap
      unzip
      distrobox
      yt-dlp
      tmux
      krdc
      kitty
    ];
    # ++ [
    #   pkgs-unstable.lunarvim
    #   # pkgs-unstable.alvr
    # ];

    sessionVariables = {
      FLAKE = "/home/mdot/dotfiles/";
    };
  };

  programs = {
  };
  # Services
  services.syncthing.enable = true;
}

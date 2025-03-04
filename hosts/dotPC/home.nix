{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Custom Modules
  plasma.enable = true;
  neovim.enable = true;
  firefox.enable = true;

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
        kdePackages.qtwebsockets
        ungoogled-chromium
        filelight
        lazygit
        logseq
        obsidian
        # nextcloud-client
        fastfetch
        obs-studio
        libcap
        unzip
        distrobox
        yt-dlp
        tmux
        krdc
        # orca-slicer
      ]
      ++ [
        # pkgs-unstable.orca-slicer
        # pkgs-unstable.seafile-client
      ];

    sessionVariables = {
      FLAKE = "/home/mdot/dotfiles/";
      EDITOR = "neovide";
      OBSIDIAN_USE_WAYLAND = 1;
    };
  };

  # Services
  services.syncthing.enable = true;
}

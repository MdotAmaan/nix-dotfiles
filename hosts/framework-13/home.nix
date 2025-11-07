{
  pkgs,
  pkgs-unstable,
  ...
}: {
  neovim.enable = true;
  firefox.enable = true;
  floorp.enable = true;
  plasma.enable = true;

  home = {
    username = "mdot";
    homeDirectory = "/home/mdot";
    stateVersion = "24.11";

    packages = with pkgs;
      [
        inkscape
        krita
        blender-hip
        # kicad
        freecad-wayland
        audacity
        kdePackages.qtmultimedia
        python3
        kdePackages.kdenlive
        # Game stuff
        prismlauncher

        # TODO: Remove later and replace with dev shells
        libcxxStdenv
        clang-tools
        clang
        cmake
        libgcc

        gnirehtet
        xournalpp
        # android-tools
        zathura
        texliveMedium
        jdk21
        #  python311Packages.west
        thunderbird
        libreoffice-qt
        kdePackages.ksshaskpass
        element-desktop
        qbittorrent
        vlc
        # pureref
        kdePackages.qtwebsockets
        ungoogled-chromium
        kdePackages.filelight
        lazygit
        # logseq
        obsidian
        fastfetch
        unzip
        distrobox
        yt-dlp
        tmux
        kdePackages.krdc
        # orca-slicer
      ]
      ++ [
        # pkgs-unstable.grayjay
        pkgs-unstable.orca-slicer
      ];

    sessionVariables = {
    };
  };

  # Services
  services.syncthing.enable = true;
}

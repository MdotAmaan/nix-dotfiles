{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Custom Modules
  plasma.enable = true;
  neovim.enable = true;
  firefox.enable = true;
  floorp.enable = true;

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
        freecad-wayland
        openscad
        audacity
        kdePackages.kdenlive
        # Game stuff
        prismlauncher
        bs-manager

        godotPackages_4_3.godot
        brave
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
        kdePackages.filelight
        lazygit
        # logseq
        obsidian
        fastfetch
        libcap
        unzip
        distrobox
        yt-dlp
        tmux
        kdePackages.krdc
        # orca-slicer
        protonvpn-gui
      ]
      ++ [
        # pkgs-unstable.orca-slicer
        # pkgs-unstable.alvr
        # pkgs-unstable.freecad
      ];

    sessionVariables = {
      EDITOR = "neovide";
      OBSIDIAN_USE_WAYLAND = 1;
    };
  };

  # Services
  services.syncthing.enable = true;

  services.easyeffects = {
    enable = true;
  };
}

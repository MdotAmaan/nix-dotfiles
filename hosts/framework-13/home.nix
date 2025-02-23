{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  host = "dotFW";
in {
  neovim.enable = true;
  firefox.enable = true;
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
        freecad
        audacity

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
        libreoffice-qt
        ksshaskpass
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
        obsidian
        # nextcloud-client
        fastfetch
        obs-studio
        unzip
        distrobox
        yt-dlp
        tmux
        krdc
      ]
      ++ [
        # pkgs-unstable.lunarvim
        pkgs-unstable.orca-slicer
      ];

    sessionVariables = {
      FLAKE = "/home/mdot/nix-dotfiles/";
    };
  };

  # Services
  services.syncthing.enable = true;
}

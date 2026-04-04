{
  pkgs,
  inputs,
  config,
  lib,
  pkgs-unstable,
  ...
}: {
  neovim.enable = true;
  firefox.enable = true;
  floorp.enable = false;
  plasma.enable = true;
  niri.enable = true;

  home = {
    username = "mdot";
    homeDirectory = "/home/mdot";
    stateVersion = "24.11";

    packages = with pkgs;
      [
        btop
        vial
        inkscape
        krita
        pkgsRocm.blender
        lightburn
        plasma-panel-colorizer
        # kicad
        freecad-wayland
        audacity
        kdePackages.qtmultimedia
        python3
        kdePackages.kdenlive
        # Game stuff
        prismlauncher
        exfatprogs

        # TODO: Remove later and replace with dev shells
        libcxxStdenv
        clang-tools
        clang
        cmake
        libgcc

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
        kdePackages.filelight
        lazygit
        # logseq
        obsidian
        fastfetch
        distrobox
        yt-dlp
        tmux
        kdePackages.krdc
        # orca-slicer
      ]
      ++ [
        # pkgs-unstable.grayjay
        # pkgs-unstable.orca-slicer
      ];

    sessionVariables = {
    };
  };
  # xdg.configFile.kdeglobals.source = let
  #   themePackage = builtins.head (
  #     builtins.filter (
  #       p: builtins.match ".*stylix-kde-theme.*" (baseNameOf p) != null
  #     )
  #     config.home.packages
  #   );
  #   colorSchemeSlug = lib.concatStrings (
  #     lib.filter lib.isString (builtins.split "[^a-zA-Z]" config.lib.stylix.colors.scheme)
  #   );
  # in "${themePackage}/share/color-schemes/${colorSchemeSlug}.colors";

  # Services
  services.syncthing.enable = true;
}

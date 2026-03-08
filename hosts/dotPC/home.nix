{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Custom Modules
  neovim.enable = true;
  firefox.enable = true;
  floorp.enable = false;
  plasma.enable = true;
  niri.enable = true;

  home = {
    username = "mdot";
    homeDirectory = "/home/mdot";
    stateVersion = "23.11";

    packages = with pkgs; [
      alacritty
      inkscape
      krita
      klassy
      kdePackages.qtmultimedia
      pkgsRocm.blender
      # kicad
      freecad-wayland
      openscad
      audacity
      kdePackages.kdenlive
      # Game stuff
      # prismlauncher
      bs-manager

      vial

      godotPackages_4_3.godot
      # TODO: Remove later and replace with dev shells
      libcxxStdenv
      cmake
      # libgcc

      android-tools
      zathura
      texliveMedium
      jdk21
      #  python311Packages.west
      thunderbird
      hyperhdr
      libreoffice-qt
      qbittorrent
      vlc
      kdePackages.qtwebsockets
      kdePackages.filelight
      lazygit
      obsidian
      fastfetch
      libcap
      unzip
      distrobox
      yt-dlp
      tmux
      kdePackages.krdc
      protonvpn-gui
    ];
    # ++ [
    #   pkgs-unstable.klassy
    # ];

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
  #  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  #    {
  #      "config" :
  #      [
  #        "~/.local/share/Steam/config"
  #      ],
  #      "external_drivers" : null,
  #      "jsonid" : "vrpathreg",
  #      "log" :
  #      [
  #        "~/.local/share/Steam/logs"
  #      ],
  #      "runtime" :
  #      [
  #        "${pkgs.opencomposite}/lib/opencomposite"
  #      ],
  #      "version" : 1
  #    }
  #  '';
}

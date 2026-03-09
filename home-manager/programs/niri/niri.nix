{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options = {
    niri.enable = lib.mkEnableOption "Enables Niri with noctalia-shell";
  };

  config = lib.mkIf config.niri.enable {
    programs = {
      # Uncomment once #1643 is resolved
      # niri = {
      #   enable = true;
      #   package = pkgs.niri-unstable;
      # };

      noctalia-shell = {
        enable = true;
      };
    };

    services.cliphist.enable = true;

    home.packages = with pkgs; [
      alacritty
      kdePackages.qt6ct
      xwayland-satellite
    ];

    # Niri config
    home.file = {
      "${config.home.homeDirectory}/.config/niri/config.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
      };

      "${config.home.homeDirectory}/.config/alacritty/alacritty.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink ./alacritty.toml;
      };
    };
  };
}

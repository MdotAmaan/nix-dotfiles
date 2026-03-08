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
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs = {
      niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

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
    home.file."${config.home.homeDirectory}/.config/niri/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
    };
  };
}

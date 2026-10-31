{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "Enables Steam";
  };
  config = lib.mkIf config.steam.enable {
    programs.steam = {
      # gamescopeSession.enable = true;
      protontricks.enable = true;
      enable = true;
      remotePlay.openFirewall = true;
    };
    environment.systemPackages = with pkgs; [
      # gamescope-wsi # HDR won't work without this
    ];
  };
}

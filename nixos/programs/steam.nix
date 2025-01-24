{
  config,
  lib,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "Enables Steam";
  };
  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}

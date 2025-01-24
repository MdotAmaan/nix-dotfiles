{
  lib,
  config,
  ...
}: {
  options = {
    zerotier.enable = lib.mkEnableOption "Enables Zerotier";
  };

  config = lib.mkIf config.zerotier.enable {
    services.zerotierone = {
      enable = false;
      localConf.settings.softwareUpdate = "disable";
    };
  };
}

{
  config,
  lib,
  ...
}: {
  options = {
    alvr.enable = lib.mkEnableOption "Enables ALVR";
  };

  config = lib.mkIf config.alvr.enable {
    programs.alvr = {
      enable = true;
      openFirewall = true;
    };
  };
}

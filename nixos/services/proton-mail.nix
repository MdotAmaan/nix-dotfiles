{
  lib,
  config,
  ...
}: {
  options = {
    protonmail-bridge.enable = lib.mkEnableOption "Enables the proton mail bridge";
  };

  config = lib.mkIf config.protonmail-bridge.enable {
    services = {
      protonmail-bridge.enable = true;
    };
  };
}

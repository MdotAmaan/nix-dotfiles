{
  config,
  lib,
  ...
}: {
  options = {
    orca-slicer.enable = lib.mkEnableOption "Enables Orca Slicer";
  };

  config = lib.mkIf config.orca-slicer.enable {
    programs.orca-slicer = {
      enable = true;
      openFirewall = true;
    };
  };
}

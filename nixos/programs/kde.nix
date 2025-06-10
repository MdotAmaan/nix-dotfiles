{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.gui == "kde") {
    desktopManager.plasma6.enable = true;

    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
}

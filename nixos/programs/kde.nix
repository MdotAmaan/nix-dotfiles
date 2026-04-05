{
  services = {
    desktopManager.plasma6.enable = true;

    displayManager.plasma-login-manager.enable = true;
    # displayManager.sddm.wayland.enable = true;
  };

  programs.kdeconnect.enable = true;
}

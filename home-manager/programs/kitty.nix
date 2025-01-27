{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    settings = {
      font_size = 12;
      confirm_os_window_close = -1;
    };
    environment = {
      "DEFAULT_USER" = "mdot";
    };

    themeFile = "GruvboxMaterialDarkHard";
  };
}

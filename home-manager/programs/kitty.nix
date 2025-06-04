{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    settings = {
      confirm_os_window_close = 0;
      close_window_with_confirmation = "ignore-shell";
      font_size = 12;
      background_opacity = 0.75;
      background_blur = 2;
    };

    environment = {
      "DEFAULT_USER" = "mdot";
    };

    themeFile = "GruvboxMaterialDarkHard";
  };
}

{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerdfonts
    fira-code
    liberation_ttf
    google-fonts
    vistafonts
  ];
}

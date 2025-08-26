{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;

    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git" "autojump"];
      theme = "agnoster";
    };
  };

  fonts.packages = with pkgs; [
    powerline-fonts
  ];

  environment.systemPackages = with pkgs; [
    autojump
  ];
}

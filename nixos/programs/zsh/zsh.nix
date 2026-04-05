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
    shellAliases = {
      ll = "ls -l";
      # nixtry = "nix shell nixpkgs#";
      nixup = "/home/mdot/nix-dotfiles/nixos/programs/zsh/update-flakes.zsh";
    };
    shellInit = ''
      nixtry() {
        nix shell "nixpkgs#"$@""
      }
    '';
  };

  fonts.packages = with pkgs; [
    powerline-fonts
  ];

  environment.systemPackages = with pkgs; [
    autojump
  ];
}

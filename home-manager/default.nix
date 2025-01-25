{...}: {
  imports = [
    ./programs/plasma.nix
    ./programs/neovim.nix
    ./programs/firefox.nix
    ./programs/lf/lf.nix
    ./programs/zsh.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "MdotAmaan";
      userEmail = "mdotamaan@protonmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };

  starship = {
    enable = true;
  };

  systemd.user.startServices = "sd-switch";
}

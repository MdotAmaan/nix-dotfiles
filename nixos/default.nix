{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/default.nix
    ./services/default.nix
    ./fonts.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.mdot = {
    isNormalUser = true;
    description = "Amaan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "adbusers"
      "kvm"
    ];
    openssh.authorizedKeys.keys = [
      # SSH public Keys
    ];
  };

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  programs = {
    gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
    ssh = {
      startAgent = true;
      enableAskPassword = true;
      askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
      addKeysToAgent = "yes";
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/mdot/nix-dotfiles/";
    };
  };
}

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix = let
    flakeInputs = lib.filterAttrs (_:lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  nixpkgs = {
    overlays = [

    ];
    config = {
      allowUnfree = true;
    };
  };

  programs.nix-ld.enable = true;
 # programs.nix-ld.libraries = with pkgs; [
 #   # Add missing dynamic libraries here instead of system
 # ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dotPC"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdot = {
    isNormalUser = true;
    description = "Amaan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      # SSH public Keys
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    wl-clipboard
    home-manager
    ripgrep
    fd
    clang
    sshfs
    cargo
    firefox
    thunderbird
    kdePackages.kdeconnect-kde
    # fish stuff
    fish
    fishPlugins.autopair
  ];

  fonts.packages = with pkgs; [
    nerdfonts
    liberation_ttf
    google-fonts
    vistafonts
  ];
  programs.kdeconnect.enable = true;
    programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };
   programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
   };
   programs.bash = {
     interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
   };

  # List services that you want to enable:
  services.flatpak = {
    enable = true;
    packages = [
      "io.mrarm.mcpelauncher" # Minecraft Bedrock Launcher
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ]; # Sunshine
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
    ]; 
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
      { from = 8000; to = 8010; } # Sunshine
    ];
  };
  system.stateVersion = "23.11"; 
}

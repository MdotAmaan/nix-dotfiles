{ inputs, lib, config, pkgs, pkgs-stable, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.nix-minecraft.nixosModules.minecraft-servers
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
      # inputs.nix-minecraft.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };
  

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    # Add missing dynamic libraries here instead of system
  ];
 
 # Docker
  virtualisation.docker.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dotPC"; # Define your hostname.

  #TODO: remove later
  hardware.keyboard.qmk.enable = true;
  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "kvm" "minecraft"];
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
    sshfs
    cargo
    firefox
    thunderbird
    kdePackages.kdeconnect-kde
    sunshine
    hunspell # dictionary
    zerotierone
    hunspellDicts.en_US
    # orca-slicer
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
  
  programs.adb.enable = true;

  programs.kdeconnect.enable = true;
    programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

   programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
   };

  # Set fish as the default shell
   programs.bash = {
     interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
    '';
   };

  services.zerotierone = {
    enable = false;
    localConf.settings.softwareUpdate = "disable";
  };

  services.sunshine = {
    autoStart = false;
    enable = true;
    applications.apps = [
      {
        name = "Desktop";
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }
      {
        name = "Drawing";
        prep-cmd = [
          {
            do = "''${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.HDMI-A-1.mode.2304x1440@120";
            undo = "''${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.HDMI-A-1.mode.3440x1440@100";
          }
        ];
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }
    ];
  };

  # Flatpak applications 
  services.flatpak = {
    enable = true;
    packages = [
      "io.mrarm.mcpelauncher" # Minecraft Bedrock Launcher
      "com.ultimaker.cura" 
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.resolved.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Open ports in the firewall.
  networking.firewall = {
    extraCommands = ''
    iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
    iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
    iptables -I INPUT -p udp -m udp --match multiport --dports 1990,2021 -j ACCEPT
    '';
    allowedTCPPorts = [ 53 47984 47989 47990 48010 25565 19132 8883 990 322 6000 123]; # Sunshine, Orcaslicer 
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
      { from = 50000; to = 50100; } # Orcaslicer
    ]; 
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
      { from = 8000; to = 8010; } # Sunshine
      { from = 47998; to = 48000; }
    ];
    allowedUDPPorts = [ 53 51820 25565 19132 123];
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = [ "wg0" ];
  };

  security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
  };
  system.stateVersion = "23.11"; 
}

{ inputs, lib, config, pkgs, pkgs-stable, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nix-minecraft.nixosModules.minecraft-servers
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
      inputs.nix-minecraft.overlay
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
    allowedTCPPorts = [ 53 47984 47989 47990 48010 25565 19132]; # Sunshine
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
    ]; 
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect 
      { from = 8000; to = 8010; } # Sunshine
      { from = 47998; to = 48000; }
    ];
    allowedUDPPorts = [ 53 51820 25565 19132];
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
# Enable WireGuard
# wg-easy
#  networking.wg-quick.interfaces = {
#    wg0 = {
#      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
#      dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
#      privateKeyFile = "MCLNgQQ5ShT2R9tSX0QBY28Qp314wgiUZa6BBCl9bXQ=";
#      
#      peers = [
#        {
#          publicKey = "QuOFuAyzDbKjiA87Asjff3VwBBlrEdb24wJQVHRU9nM=";
#          presharedKeyFile = "cQl1s+99E/t/RBSLcMbTTU+ciEMp4utAKAqoJTF6JkI=";
#          allowedIPs = [ "0.0.0.0/0" "::/0" ];
#          endpoint = "t.amaanlab.com:51820";
#          persistentKeepalive = 25;
#        }
#      ];
#    };
#  };
 # networking.wireguard.interfaces = {
 #   # "wg0" is the network interface name. You can name the interface arbitrarily.
 #   wg0 = {
 #     # Determines the IP address and subnet of the client's end of the tunnel interface.
 #     ips = [ "10.8.0.5/24" ];
 #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
 # 
 #     privateKeyFile = "/root/wireguard-keys/privatekey";
 # 
 #     peers = [
 #       # For a client configuration, one peer entry for the server will suffice.
 # 
 #       {
 #         # Public key of the server (not a file path).
 #         publicKey = "QuOFuAyzDbKjiA87Asjff3VwBBlrEdb24wJQVHRU9nM";
 # 
 #         # Forward all the traffic via VPN.
 #         allowedIPs = [ "0.0.0.0/0" ];
 #         # Or forward only particular subnets
 #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
 # 
 #         # Set this to the server IP and port.
 #         endpoint = "t.amaanlab.com:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
 # 
 #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
 #         persistentKeepalive = 25;
 #       }
 #     ];
 #   };
 # };
  system.stateVersion = "23.11"; 
}

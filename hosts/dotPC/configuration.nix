{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Custom Modules
  sunshine.enable = true;
  zerotier.enable = true;
  tailscale.enable = false;
  steam.enable = true;
  # orca-slicer.enable = false;

  alvr.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;

  networking = {
    hostName = "dotPC";
    networkmanager.enable = true;

    firewall = {
      enable = false;
      # Enable multicast ports to discover local devices
      extraCommands = ''
        iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -I INPUT -p udp -m udp --match multiport --dports 1989,2021 -j ACCEPT
      '';
      checkReversePath = false; # Get wireguard to work
      allowedTCPPorts = [
        11434 #Ollama
        9943
        9944
        53
        25565 # Minecraft Java
      ];
      # allowedTCPPortRanges = [
      #   {
      #   }
      # ];
      # allowedUDPPortRanges = [
      #   {
      #   }
      # ];
      allowedUDPPorts = [
        11434
        9943
        9944
        53
        51820
        19132 # Minecraft Server
      ];
    };

    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  time.timeZone = "America/Detroit";

  services = {
    power-profiles-daemon.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh.enable = true;
    resolved.enable = true;

    printing.enable = true;
  };

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      libGL
      # add missing dynamic libraries here instead of system
    ];

    partition-manager.enable = true;
    adb.enable = true;
    kdeconnect.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    wl-clipboard
    home-manager
    ripgrep
    fd
    sshfs
    cargo
    orca-slicer
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];

  systemd.targets = {
    sleep.enable = true;
    suspend.enable = true;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}

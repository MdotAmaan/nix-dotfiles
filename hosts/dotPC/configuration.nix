{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./vfio.nix
  ];

  # Custom Modules
  sunshine.enable = true;
  zerotier.enable = false;
  tailscale.enable = false;
  steam.enable = true;
  protonmail-bridge.enable = true;
  # orca-slicer.enable = false;

  alvr.enable = false;
  boot = {
    kernelParams = ["intel_iommu=on"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

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
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args.pulse = {
            min.req = "32/48000";
            default.req = "32/48000";
            max.req = "32/48000";
            min.quantum = "32/48000";
            max.quantum = "32/48000";
          };
        }
      ];
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    wl-clipboard
    home-manager
    ripgrep
    fd
    sshfs
    cargo
    darkly
    nur.repos.shadowrz.klassy-qt6
    qalculate-qt
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

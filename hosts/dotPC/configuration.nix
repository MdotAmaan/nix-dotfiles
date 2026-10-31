{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./vfio.ni
  ];
  options = {
    gui = lib.mkOption {default = "kde";};
  };

  config = {
    host = "dotPC";
    gui = "kde";

    nixpkgs.overlays = [
      inputs.niri.overlays.niri
      # (final: prev: {
      #   opentabletdriver = prev.opentabletdriver.overrideAttrs (old: rec {
      #     version = "0.6.7";
      #     src = prev.fetchFromGitHub {
      #       owner = "OpenTabletDriver";
      #       repo = "OpenTabletDriver";
      #       tag = "v${version}";
      #       hash = "sha256-jL3d1DjY9n85BrO6ajZVvJMHmPYfxng4YE25s/9hfGA="; # replace
      #     };
      #   });
      # })
    ];
    boot = {
      kernelParams = ["intel_iommu=on"];
      # Steam frame stuff
      kernelPackages = pkgs.linuxPackages_latest;
      extraModprobeConfig = ''
        options cfg80211 ieee80211_regdom=US
      '';

      initrd.kernelModules = ["amdgpu"];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
      }
    ];

    virtualisation = {
      docker.enable = true;
      waydroid.enable = false;
    };

    networking = {
      hostName = config.host;
      networkmanager.enable = true;
      firewall = {
        enable = false;
        extraCommands = ''
          iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
          iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
          iptables -I INPUT -p udp -m udp --match multiport --dports 1989,2021 -j ACCEPT
        '';
        checkReversePath = false; # Get wireguard to work
        allowedTCPPorts = [
          3240
          3080 # Librechat
          #ALVR
          9943
          9944
          53
          8089
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
      amdgpu.overdrive.enable = true;
      enableRedistributableFirmware = true;
      opentabletdriver = {
        enable = true;
        # package = use overlay here maybe?;
      };
      keyboard.qmk.enable = true;
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

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      ollama = {
        enable = false;
        package = pkgs.ollama-rocm;
        host = "0.0.0.0";
      };

      librechat = {
        enable = false;
        enableLocalDB = true;
        openFirewall = true;
        credentialsFile = /home/mdot/.librechat.env;
      };
      openssh.enable = true;
      resolved.enable = true;

      printing.enable = true;
    };

    users.groups.libvirtd.members = ["mdot"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    programs = {
      niri.enable = false;
      xppen.enable = false;
      # xppen-enable = true;
      gamemode.enable = true;
      # gamescope = {
      #   enable = true;
      #   capSysNice = true;
      # };

      appimage = {
        enable = true;
        binfmt = true;
      };

      nix-ld.enable = true;
      nix-ld.libraries = with pkgs; [
        # stdenv.cc.cc.lib
        zlib
        libGL
        # add missing dynamic libraries here instead of system
      ];

      virt-manager.enable = false;
      partition-manager.enable = true;
      kdeconnect.enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
    ''; # Moza boxflat udev rules

    services.lact = {
      enable = true;
    };

    services.wivrn = {
      enable = false;
      openFirewall = true;

      autoStart = true;
    };

    services.monado = {
      enable = false;
      defaultRuntime = true;
    };

    #    jovian = {
    # steam = {
    #   enable = true;
    #   desktopSession = "plasma";
    #   user = "mdot";
    # };
    # hardware.has.amd.gpu = true;
    #    };

    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.systemPackages = with pkgs; [
      iw # Needed for steam frame
      platformio
      boxflat

      python3
      vscode-fhs
      tesseract
      android-tools
      p7zip
      linuxHeaders
      clang-tools
      clang
      glibc
      wget
      wl-clipboard
      home-manager
      ripgrep
      fd
      sshfs
      cargo
      darkly
      qalculate-qt
      aspell
      aspellDicts.en

      wayvr
    ];

    systemd.targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    system.stateVersion = "23.11";
  };
}

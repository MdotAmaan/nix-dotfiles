{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    # Make sure the module targets the same kernel as your system is using.
    kernel = config.boot.kernelPackages.kernel;
  };
  amdgpu-ignore-ctx-privileges = builtins.fetchurl {
    url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
    sha256 = "sha256:0ya6b43m0ncjbyi6vyq3ipwwx6yj24cw8m167bd6ikwvdz5yi887";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./vfio.nix
  ];
  options = {
    gui = lib.mkOption {default = "kde";};
  };

  config = {
    host = "dotPC";
    gui = "kde";

    nixpkgs.overlays = [inputs.niri.overlays.niri];
    boot = {
      #     extraModulePackages = [
      #       (amdgpu-kernel-module.overrideAttrs (_: {
      #         patches = [amdgpu-ignore-ctx-privileges];
      #       }))
      #     ];
      kernelParams = ["intel_iommu=on"];
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
      waydroid.enable = true;
    };

    networking = {
      hostName = config.host;
      networkmanager.enable = true;
      firewall = {
        enable = true;
        extraCommands = ''
          iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
          iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
          iptables -I INPUT -p udp -m udp --match multiport --dports 1989,2021 -j ACCEPT
        '';
        checkReversePath = false; # Get wireguard to work
        allowedTCPPorts = [
          3240
          #ALVR
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
      opentabletdriver.enable = true;
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

      openssh.enable = true;
      resolved.enable = true;

      printing.enable = true;
    };

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["mdot"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    programs = {
      xppen.enable = false;
      corectrl.enable = true;
      # xppen-enable = true;
      # envision.enable = true;
      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = true;
      };

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

      partition-manager.enable = true;
      kdeconnect.enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];

    services.wivrn = {
      enable = true;
      openFirewall = true;

      defaultRuntime = true;
      autoStart = true;
    };

    environment.systemPackages = with pkgs; [
      platformio
      arduino-ide

      python3
      rustup
      espup
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
      aspellDicts.en-computers
      aspellDicts.en-science

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

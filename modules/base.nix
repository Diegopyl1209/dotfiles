{
  lib,
  host,
  pkgs,
  config,
  inputs,
  system,
  username,
  userfullname,
  ...
}: {
  # User
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager" "adbusers"];
    description = userfullname;
    shell = pkgs.zsh;
  };
  users.groups.media = {
    gid = 1800;
    members = [
      username
    ];
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    # Bootloader.
    loader.grub = {
      enable = lib.mkForce true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      extraConfig = "
        terminal_input console
        terminal_output console
      ";
    };

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    plymouth.enable = config.hm.home-manager.graphical.enable;
  };

  # Fix USB sticks not mounting or being listed:
  services.devmon.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Bash shebang
  services.envfs.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = ["kitty.desktop"];
    };
  };

  services.tailscale.enable = true;
  #services.netbird.enable = true;

  # Hardware
  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  zramSwap = {
    enable = true;
  };

  # Adb
  programs.adb.enable = true;
  # docker
  virtualisation.docker.enable = true;
  # Networking
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    firewall.enable = lib.mkForce true;
  };
  services.blueman.enable = config.hm.home-manager.bluetooth.enable;
  systemd.services.NetworkManager-wait-online.enable = false;
  # XDG Desktop Portal stuff
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  # X server
  services.xserver = {
    enable = config.hm.home-manager.graphical.enable;
    excludePackages = with pkgs; [xterm];
  };

  /*
  services.displayManager.sddm = {
    enable = lib.mkForce config.hm.home-manager.graphical.enable;
    wayland.enable = true;
    sugarCandyNix = {
      enable = true; # This enables SDDM automatically and set its theme to
      # "sddm-sugar-candy-nix"
      settings = with config.hm.colorScheme.palette; {
        # Set your configuration options here.
        # Here is a simple example:
        Background = lib.cleanSource ../home/desktop/hyprland/wallpapers/${config.hm.home-manager.wallpaper};
        FormPosition = "right";
        HaveFormBackground = true;
        PartialBlur = true;
        OverrideLoginButtonTextColor = "#${base05}";
        MainColor = "#${base05}";
        AccentColor = "#${base07}";
        BackgroundColor = "#${base00}";
        # ...
      };
    };
  };
  */

  # Printing support
  services.printing = {
    enable = true;
    browsed.enable = false;
    openFirewall = true;
  };
  security.polkit.enable = true;
  # Flatpak
  services.flatpak.enable = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true; # (optional)
  };
  programs.noisetorch.enable = true;

  # Locate
  services.locate = {
    enable = true;
  };

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    hostKeys = [
      {
        path = "/home/${username}/.ssh/id_ed25519";
        type = "ed25519";
      }
    ];
  };
  # Locale
  time.timeZone = "America/Santiago";

  # Internationalisation
  i18n.defaultLocale = "es_MX.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Env packages
  environment.systemPackages = with pkgs; [
    nh
    virt-manager
    gnome-disk-utility
    gutenprint
    git
    btrfs-progs
    btrfs-snap
    curl
    wget
    jq
    polkit
    polkit_gnome
  ];

  environment.sessionVariables = {
    FLAKE = "/home/${username}/nixos-config";
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.ubuntu-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    font-awesome
    manrope
    inter
    lexend
    material-design-icons
    meslo-lg
    meslo-lgs-nf
  ];

  # Virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        vhostUserPackages = [pkgs.virtiofsd];
        ovmf.enable = true;
      };
    };
  };
  virtualisation.waydroid.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # Enable needed programs
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };
  # Nixos docs
  documentation = {
    nixos.enable = false;
    info.enable = false;
    man.enable = false;
  };
  # System stateversion
  system.stateVersion = "23.05";
}

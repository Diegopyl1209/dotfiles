# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "amdgpu" ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.gfxmodeEfi="1280x800";
  boot.loader.grub.gfxmodeBios="1280x800";
  
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.driSupport = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b91c023d-60aa-434f-9c45-40520ca07f17";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9C40-4332";
      fsType = "vfat";
    };
  
  fileSystems."/mnt/Disco1" =
    { device = "/dev/disk/by-uuid/8b9897ad-59ba-4020-b7a8-594943a2f648";
      fsType = "btrfs";
    };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 32*1024;
  } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

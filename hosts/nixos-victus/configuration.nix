{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  #Windows partition
  fileSystems."/mnt/Windows" = {
    device = "/dev/disk/by-label/WINDOWS";
    fsType = "ntfs-3g";
    options = [ "defaults" "uid=1000" "gid=100" "nofail" "x-gvfs-show" ];
  };

  #Windows entry
  boot.loader.limine.extraEntries = ''
        /+Windows
          //Windows
            protocol: efi
            path: fslabel(WINBOOT):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

  boot.loader.limine.efiInstallAsRemovable = true;

  networking.hostName = "nixos-victus";
  networking.networkmanager.enable = true;


  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  programs.omenctl = {
    enable = true;
    loadCustomDriver = true; # Loads the custom hp-wmi and hp-rgb-lighting kernel modules
  };

  
  # Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = [     
  ];
}


{ config, ... }:

{
  imports =
    [
      ../../default.nix
      ../../modules/omen-space.nix
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

  hardware.omen-space = {
    rgb = {
      mode = "static";            # breathing, wave, rainbow, aurora, ...
      colors = [ "00FFAA" ];
      brightness = 70;
    };

    undervolt = {
      curveOptimizer = -10;       # -30..30
      tccOffset = 0;              # max temp = 100 - offset
    };

    power.limits = {
      enable = true;              
      pl1 = 45;
      pl2 = 115;
    };
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  
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
}


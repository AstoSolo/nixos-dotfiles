{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];


  boot.loader.limine.efiInstallAsRemovable = true;
  #Windows entry
  boot.loader.limine.extraEntries = ''
        /+Windows
          //Windows
            protocol: efi
            path: uuid(0144d536-c245-416f-b540-6c55bfdac959):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

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
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    
  ];
}


{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
      ./disko.nix
    ];

  fileSystems."/mnt/hard-drive-data" = {
    device = "/dev/disk/by-label/Hard\\x20Drive\\x20Data";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=100" ];
  };

  boot.loader.limine.efiInstallAsRemovable = true;

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;


  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [    
    rocmPackages.rocm-smi
  ];
}

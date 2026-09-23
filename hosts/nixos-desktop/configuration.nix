{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];


  boot.loader.limine.efiInstallAsRemovable = true;

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;


  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = [     
  ];
}

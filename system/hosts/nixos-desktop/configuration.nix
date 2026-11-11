{ pkgs, ... }:

{
  imports =
    [
      ../../default.nix
      ./hardware-configuration.nix
      ./disko.nix
    ];

  fileSystems."/mnt/hard-drive-data" = {
    device = "/dev/disk/by-label/Hard\\x20Drive\\x20Data";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=100" ];
  };
  
  boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "amdgpu" ];
  boot.kernelParams = [
    "video=DP-3:1920x1080@60"
    "amd_iommu=on" "iommu=pt"
    "vfio-pci.ids=1002:1638,1002:1637"   # iGPU Cezanne + HDMI-audio
    ];
  
  boot.extraModprobeConfig = ''
    softdep amdgpu pre: vfio-pci
    softdep snd_hda_intel pre: vfio-pci
  '';

  boot.loader.limine = {
    efiInstallAsRemovable = true;
    resolution = "2560x1440";
    style.interface.resolution = "2560x1440";
    extraConfig = ''
      default_entry: 2
    '';
    };

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;


  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [    
    rocmPackages.rocm-smi
  ];
}

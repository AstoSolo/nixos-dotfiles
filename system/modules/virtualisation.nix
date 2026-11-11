{pkgs, ...}:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virt-viewer
    virtio-win
    virtiofsd
    win-spice
  ];

  users.groups.libvirtd.members = ["astosolo"];
}

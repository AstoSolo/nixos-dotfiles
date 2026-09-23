{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "NIXBOOT";
              name = "ESP";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n" "NIXBOOT" ];
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              label = "NIXROOT";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "NIXROOT" "-f" ];
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
                subvolumes = {
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

{ inputs, config, ... }:
{
  flake.diskoConfigurations.little-ghost = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_4000GB_25033U801640";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
        nodev = {
          "/tmp" = {
            fsType = "tmpfs";
            mountOptions = [ "size=200M" ];
          };
        };
      };
    };
  };
}

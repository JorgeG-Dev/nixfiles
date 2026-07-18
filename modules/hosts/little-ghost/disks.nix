{ inputs, config, ... }:
{
  flake.diskoConfigurations.little-ghost = {
    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persistent".neededForBoot = true;
    disko.devices.nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };
    };
    disko.devices.disk.main = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_4000GB_25033U801640";
      type = "disk";
      content.type = "gpt";
      content.partitions.ESP = {
        size = "1G";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      content.partitions.swap = {
        size = "64G";
        content = {
          type = "swap";
          resumeDevice = true;
        };
      };
      content.partitions.root = {
        name = "root";
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];

          subvolumes = {
            "/persistent" = {
              mountOptions = [
                "subvol=persistent"
                "compress=zstd"
                "noatime"
              ];
              mountpoint = "/persistent";
            };

            "/nix" = {
              mountOptions = [
                "subvol=nix"
                "compress=zstd"
                "noatime"
              ];
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };

  flake.modules.nixos.little-ghost = {
    # Declare the hashed password here since we don't necessarily need a hashed
    # password on each system, only those where preservation is a thing
    users.users.${config.flake.aspects.owner.username}.hashedPasswordFile = "/persistent/passwd";
    preservation = {
      enable = true;
      preserveAt."/persistent" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key";
            how = "symlink";
            configureParent = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            how = "symlink";
            configureParent = true;
          }
          {
            file = "/var/lib/systemd/random-seed";
            how = "symlink";
            inInitrd = true;
            configureParent = true;
          }
        ];

        directories = [
          "/var/lib/systemd/timers"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/var/lib/docker"
          "/var/lib/systemd/coredump"
          "/var/log"
          "/etc/NetworkManager/system-connections"
          "/etc/nixos"
        ];

        users.${config.flake.aspects.owner.username} = {
          files = [
            ".zsh_history"
          ];
          directories = [
            "Projects"
            "Documents"
            "Pictures"
            "Downloads"
            ".local/state/wireplumber"
            ".local/state/nvim"
            ".local/state/nix"
            {
              directory = ".ssh";
              mode = "0700";
            }
            ".mozilla"
          ];
        };
      };
    };
  };
}

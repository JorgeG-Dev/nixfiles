{ inputs, config, ... }:
{
  flake.modules.nixos.little-ghost = {

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/602227a0-f590-4166-a7b9-2dc8dcd56b1c";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/09D6-CE26";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    fileSystems."/mnt/storage" = {
      device = "/dev/disk/by-uuid/2b026685-8c4a-4cfc-b731-2efcad68b204";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "users"
        "nofail"
        "exec"
      ];
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/8e596c9c-619b-4dc7-b918-30add134c54f"; }
    ];

  };
}

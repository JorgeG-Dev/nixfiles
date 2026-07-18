{ inputs, config, ... }:
{
  flake.modules.nixos.little-ghost = {

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/d2784273-8ef3-4f71-85c7-312c4e2c4ee2";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/E16B-DFED";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/33677fc0-2151-4bc0-bd32-ffe5e9bcc9f5"; }
    ];

  };
}

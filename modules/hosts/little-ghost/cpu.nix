{ ... }:
{
  flake.modules.nixos.little-ghost =
    {
      config,
      lib,
      ...
    }:
    {
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

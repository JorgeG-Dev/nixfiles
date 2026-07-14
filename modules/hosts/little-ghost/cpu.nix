{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.little-ghost =
    {
      modulesPath,
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

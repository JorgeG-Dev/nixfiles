{ inputs, config, ... }:
{
  flake.modules.nixos.little-ghost = {
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}

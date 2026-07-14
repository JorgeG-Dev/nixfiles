{ inputs, config, ... }:
{
  flake.modules.nixos.little-ghost = {
    networking.hostName = "little-ghost";
  };
}

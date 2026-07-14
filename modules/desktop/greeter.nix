{ inputs, config, ... }:
{
  flake.modules.nixos.desktop = {
    services.displayManager.sddm.enable = true;
  };
}

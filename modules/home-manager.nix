{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.core = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
  };

  flake.modules.darwin.core = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
  };

  flake.modules.homeManager.core = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}

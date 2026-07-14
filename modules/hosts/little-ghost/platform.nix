{
  inputs,
  config,
  lib,
  modulesPath,
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
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}

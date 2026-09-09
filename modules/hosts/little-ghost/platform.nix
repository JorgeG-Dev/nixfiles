{ ... }:
{
  flake.modules.nixos.little-ghost =
    {
      modulesPath,
      lib,
      ...
    }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}

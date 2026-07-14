{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.core =
    { pkgs, lib, ... }:
    {
      programs.firefox = {
        enable = true;
      };
    };
}

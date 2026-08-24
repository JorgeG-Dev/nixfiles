{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
      ];
    };

  flake.modules.darwin.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
        openspec
      ];
    };
}

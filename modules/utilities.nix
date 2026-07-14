{
  inputs,
  config,
  pkgs,
  ...
}:
{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
      ];

      services.printing.enable = true;
    };
}

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
        wl-clipboard
      ];

      services.printing.enable = true;
    };
}

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
        bcompare
      ];

      services.printing.enable = true;
    };
}

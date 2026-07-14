{
  inputs,
  config,
  pkgs,
  ...
}:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraPackages = with pkgs; [ hidapi ];
        package = pkgs.steam.override {
          extraArgs = "-system-composer";
        };
      };
      programs.gamemode = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        heroic
        discord
        mangohud
      ];
      hardware.steam-hardware.enable = true;
    };

  flake.modules.darwin.gaming = {
    homebrew.casks = [
      "steam"
      "discord"
    ];
  };
}

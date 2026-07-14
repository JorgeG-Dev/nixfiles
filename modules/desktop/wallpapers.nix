{ inputs, config, ... }:
{
  flake.modules.homeManager.desktop = {
    home.file."Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
}

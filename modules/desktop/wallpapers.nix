{ ... }:
let
  # Home-relative so the module that places the files and the modules that
  # consume them (noctalia) can't drift apart.
  base = "Pictures/Wallpapers";
in
{
  flake.aspects.wallpapers = {
    directory = base;
    ultrawide = "${base}/3440x1440";
    retina = "${base}/retina";
  };

  flake.modules.homeManager.desktop = {
    home.file.${base} = {
      source = ./wallpapers;
      recursive = true;
    };
  };
}

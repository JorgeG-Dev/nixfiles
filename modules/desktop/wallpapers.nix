{ config, ... }:
let
  owner = config.flake.aspects.owner.username;

  # Home-relative so the module that places the files and the modules that
  # consume them (noctalia) can't drift apart.
  base = "Pictures/Wallpapers";

  # Keyed by host.wallpapers.set. Each set keeps its own subdirectory so the
  # aspect paths below stay valid whichever set a host installs.
  subdirs = {
    ultrawide = "3440x1440";
    retina = "retina";
  };

  # Only the selected set is copied. This lives in the platform aspects rather
  # than homeManager.desktop because host.wallpapers.set is an OS-level option,
  # and because that aspect is imported on both platforms.
  installFor =
    osConfig:
    let
      subdir = subdirs.${osConfig.host.wallpapers.set};
    in
    {
      home-manager.users.${owner}.home.file."${base}/${subdir}" = {
        source = ./wallpapers + "/${subdir}";
        recursive = true;
      };
    };
in
{
  flake.aspects.wallpapers = {
    directory = base;
    ultrawide = "${base}/${subdirs.ultrawide}";
    retina = "${base}/${subdirs.retina}";
  };

  flake.modules.nixos.desktop = { config, ... }: installFor config;
  flake.modules.darwin.desktop = { config, ... }: installFor config;
}

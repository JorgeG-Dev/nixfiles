{ lib, ... }:
let
  # Both platforms need this: little-ghost is nixos, hornet is darwin, and each
  # installs only the wallpaper set that fits its display. See wallpapers.nix.
  wallpaperSet = {
    options.host.wallpapers.set = lib.mkOption {
      type = lib.types.enum [
        "ultrawide"
        "retina"
      ];
      description = ''
        Which wallpaper set this host installs. Only the chosen set is copied
        into the home directory, so a host never carries wallpapers cut for a
        display it doesn't have. Deliberately has no default: a new host should
        state what its display is rather than quietly inherit the wrong set.
      '';
    };
  };
in
{
  flake.modules.nixos.desktop = {
    imports = [ wallpaperSet ];

    options.host.monitors.configs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            connector = lib.mkOption { type = lib.types.str; };
            width = lib.mkOption { type = lib.types.int; };
            height = lib.mkOption { type = lib.types.int; };
            refreshRate = lib.mkOption { type = lib.types.str; };
            scale = lib.mkOption {
              type = lib.types.float;
              default = 1.0;
            };
          };
        }
      );
      # Empty means "let niri autodetect", which keeps the desktop aspect usable
      # on a host that hasn't declared its displays yet.
      default = { };
    };
  };

  flake.modules.darwin.desktop = wallpaperSet;
}

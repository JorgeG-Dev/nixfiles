{ lib, ... }:
{
  flake.modules.nixos.desktop = {
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
    };
  };
}

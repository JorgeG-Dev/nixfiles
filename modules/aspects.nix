{ lib, config, ... }:
{
  options.flake.aspects = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    default = { };
  };
}

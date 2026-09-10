{ lib, ... }:
{
  options.flake.aspects = lib.mkOption {
    # Facts are mostly strings, but a few are naturally numeric (cursor size),
    # and holding those as strings only forces a toString/toInt round-trip at
    # every consumer.
    type = lib.types.attrsOf (
      lib.types.attrsOf (lib.types.either lib.types.str lib.types.int)
    );
    default = { };
  };
}

{ config, ... }:
let
  # Theme name and size come from the cursor aspect so the greeter and the
  # session can't drift apart.
  cursor = config.flake.aspects.cursor;
in
{
  flake.modules.nixos.desktop =
    { lib, pkgs, ... }:
    {
      services.displayManager.defaultSession = lib.mkForce "niri";

      services.displayManager.noctalia-greeter = {
        enable = true;

        # The greeter runs as greetd's own user, so it never sees the
        # home-manager cursor config in cursor.nix and needs the theme pointed
        # out separately. Upstream defaults cursorTheme.package to null, which
        # leaves the greeter with no cursor path at all -- the same reason the
        # session cursor was oversized. The module bakes an absolute store path
        # into greeter.toml, so this does not rely on XCURSOR_PATH.
        cursorTheme = {
          package = pkgs.kdePackages.breeze;
          name = cursor.theme;
        };

        # cursorTheme covers `theme` and `path` but not `size`, so that one
        # goes through settings directly.
        settings.cursor.size = cursor.size;
      };
      # TODO: Wait for noctalia-greeter module to be updated to enable the auto-sync feature
      # Doing it manually is a bit janky.
    };
}

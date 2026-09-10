{ config, ... }:
let
  owner = config.flake.aspects.owner.username;

  # The directory name, not the `Name=` field in index.theme: xcursor resolves
  # themes by directory, so this stays "breeze_cursors" even though KDE presents
  # it as "Breeze Dark". Breeze_Light is the other set kdePackages.breeze ships,
  # and breeze_cursors is the one that matches noctalia's dark theme.
  theme = "breeze_cursors";

  # Breeze's native size, and the same number niri defaults to. DP-1 runs at
  # scale 1, so there is nothing to multiply this by.
  size = 24;
in
{
  # Registered so tiling.nix can point niri at the same theme and greeter.nix can
  # dress the login screen to match, without either restating the name or size.
  flake.aspects.cursor = {
    inherit theme size;
  };

  # home.pointerCursor asserts platforms.linux, so this belongs in the nixos
  # aspect rather than homeManager.desktop -- that aspect is imported on darwin
  # too. Same reasoning as niri and noctalia in tiling.nix.
  flake.modules.nixos.desktop = {
    home-manager.users.${owner} =
      { pkgs, ... }:
      {
        # With no cursor theme anywhere on XCURSOR_PATH, niri cannot resolve a
        # theme at all ("error loading xcursor default@24: no default icon") and
        # draws its built-in fallback bitmap, which renders much larger than any
        # themed cursor. plasma6 used to supply Breeze; once it was removed
        # nothing did. This puts the theme back and pins the size.
        #
        # dotIcons is on by default, so this also writes ~/.icons/default
        # pointing at the theme, keeping the bare name "default" resolvable for
        # clients that ask for it by that name rather than by ours.
        home.pointerCursor = {
          enable = true;
          package = pkgs.kdePackages.breeze;
          name = theme;
          inherit size;
          gtk.enable = true;
        };

        # pointerCursor's gtk.enable only sets gtk.cursorTheme, which the gtk
        # module drops unless it is enabled. font, theme and iconTheme all stay
        # null, so enabling it here writes the cursor keys and nothing else.
        gtk.enable = true;
      };
  };
}

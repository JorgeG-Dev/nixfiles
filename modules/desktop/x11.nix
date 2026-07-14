{ inputs, config, ... }:
{
  flake.modules.nixos.desktop = {
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}

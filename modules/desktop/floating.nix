{ ... }:
{
  # While not necessarily floating related, keep the desktop clean of clutter
  flake.modules.darwin.desktop = {
    system.defaults.finder.CreateDesktop = false;
    system.defaults.screencapture.location = "~/Screenshots";
  };
}

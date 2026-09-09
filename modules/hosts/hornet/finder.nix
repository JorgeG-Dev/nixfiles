{ ... }:
{
  flake.modules.darwin.hornet = {
    # CreateDesktop is set by the desktop aspect (desktop/floating.nix), which
    # owns keeping the desktop free of clutter for every darwin host.
    system.defaults.finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
    };
  };
}

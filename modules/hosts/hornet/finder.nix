{ inputs, config, ... }:
{
  flake.modules.darwin.hornet = {
    system.defaults.finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      CreateDesktop = false;
    };
  };
}

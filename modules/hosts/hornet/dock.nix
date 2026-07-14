{ inputs, config, ... }:
{
  flake.modules.darwin.hornet = {
    system.defaults.dock = {
      autohide = true;
      show-recents = false;
      mineffect = "scale";
      mru-spaces = false;
      orientation = "bottom";
    };
  };
}

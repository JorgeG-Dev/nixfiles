{ inputs, config, ... }:
{
  flake.modules.darwin.hornet = {
    system.defaults.trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };
}

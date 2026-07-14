{ inputs, config, ... }:
{
  flake.modules.nixos.core = {
    time.timeZone = "America/New_York";
  };

  flake.modules.darwin.core = {
    time.timeZone = "America/New_York";
  };
}

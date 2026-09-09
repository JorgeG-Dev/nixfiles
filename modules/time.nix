{ ... }:
let
  timeModule = {
    time.timeZone = "America/New_York";
  };
in
{
  flake.modules.nixos.core = timeModule;
  flake.modules.darwin.core = timeModule;
}

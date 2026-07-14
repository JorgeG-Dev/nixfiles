{ ... }:
{
  flake.modules.nixos.little-ghost =
    { ... }:
    {
      host.monitors.configs = {
        msi-mpg341xc = {
          connector = "DP-1";
          width = 3440;
          height = 1440;
          refreshRate = "239.999";
        };
      };
    };
}

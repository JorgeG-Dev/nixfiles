{
  lib,
  config,
  ...
}:
let
  # Bound at the flake-parts level so the home-manager module below can take its
  # own `config` argument without losing access to the aspect.
  wallpapers = config.flake.aspects.wallpapers;
  owner = config.flake.aspects.owner.username;
  emulator = config.flake.aspects.terminal.emulator;
in
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      ...
    }:
    let
      # Bound out here because `config` inside the home-manager module below is
      # the home-manager config, not this one.
      wallpaperDir = wallpapers.${config.host.wallpapers.set};

      # niri spells displays as a repeated `output "<connector>" { ... }` node,
      # which the KDL generator expresses as `_children` entries carrying `_args`.
      # Empty (the default) emits nothing, leaving niri to autodetect.
      outputs = lib.mapAttrsToList (_name: m: {
        output = {
          _args = [ m.connector ];
          mode = "${toString m.width}x${toString m.height}@${m.refreshRate}";
        };
      }) config.host.monitors.configs;
    in
    {
      # The NixOS module owns the session: it registers niri with the display
      # manager via sessionPackages, wires up portals and dbus, and supplies the
      # systemd drop-in that keeps niri-session's imported PATH intact. Only the
      # configuration itself lives in home-manager.
      programs.niri.enable = true;

      services.displayManager.defaultSession = lib.mkForce "niri";
      services.displayManager.noctalia-greeter = {
        enable = true;
      };
      # TODO: Wait for noctalia-greeter module to be updated to enable the auto-sync feature
      # Doing it manually is a bit janky.

      # wayland.windowManager.niri and programs.noctalia are both Linux-only
      # home-manager modules, so they live here instead of in homeManager.desktop
      # -- that aspect is imported on darwin too, which would need a platform
      # guard to stay evaluable.
      home-manager.users.${owner} =
        # `config` here is the home-manager config, not the NixOS one above
        {
          config,
          pkgs,
          ...
        }:
        {
          wayland.windowManager.niri = {
            enable = true;

            # The NixOS module above already installs the systemd units and the
            # portal; leaving these enabled would have home-manager shadow both
            # with a second copy. `package` stays at its default so checkConfig
            # still runs `niri validate` over the generated KDL at build time.
            systemd.enable = false;
            portalPackage = null;

            settings = {
              # xwaylandSatellitePackage already puts this on PATH. Pinning the
              # absolute store path as well covers niri spawning it by name.
              xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
              binds = {
                "Super+Return".spawn = emulator;
                "Super+C".close-window = { };
                "Super+H".focus-column-left = { };
                "Super+J".focus-workspace-down = { };
                "Super+K".focus-workspace-up = { };
                "Super+L".focus-column-right = { };
                "Super+Shift+H".move-column-left = { };
                "Super+Shift+J".move-column-to-workspace-down = { };
                "Super+Shift+K".move-column-to-workspace-up = { };
                "Super+Shift+L".move-column-right = { };
                "Super+F".maximize-column = { };
                "Super+Shift+F".fullscreen-window = { };
                "Super+BracketLeft".consume-or-expel-window-left = { };
                "Super+BracketRight".consume-or-expel-window-right = { };
                "Super+Space".spawn-sh = "noctalia msg panel-toggle launcher";
                "Super+S".spawn-sh = "noctalia msg panel-toggle control-center";
              };
              input.keyboard.xkb.layout = "us";
              spawn-at-startup = [ "noctalia" ];
              layout = {
                default-column-width = {
                  proportion = 0.5;
                };
              };
              hotkey-overlay = {
                skip-at-startup = { };
              };
              window-rule = {
                geometry-corner-radius = 20;
                clip-to-geometry = true;
                draw-border-with-background = false;
              };
              _children = outputs;
            };
          };

          programs.noctalia = {
            enable = true;
            settings = {
              theme = {
                mode = "dark";
              };
              wallpaper = {
                enabled = true;
                directory = "${config.home.homeDirectory}/${wallpaperDir}";
                fill_mode = "crop";
                transition_duration = 1500;
                transition_on_startup = true;
                automation = {
                  enabled = true;
                  interval_seconds = 60;
                  order = "random";
                  recursive = true;
                };
              };
              shell = {
                polkit_agent = true;
              };
            };
          };
        };
    };
}

{
  self,
  inputs,
  lib,
  config,
  ...
}:
let
  # Bound at the flake-parts level so the home-manager module below can take its
  # own `config` argument without losing access to the aspect.
  wallpapers = config.flake.aspects.wallpapers;
in
{
  # Need to limit what gets built based on system type
  perSystem =
    { pkgs, ... }:
    {
      wrappers.control_type = "exclude";
      wrappers.packages = {
        niri = !pkgs.stdenv.hostPlatform.isLinux;
      };
    };

  flake.wrappers.niri =
    { pkgs, wlib, ... }:
    {
      # By adding the custom noctalia wrapper as an extra package, we ensure
      # niri can access it on the PATH
      runtimePkgs = [
        pkgs.xwayland-satellite
      ];
      imports = [ wlib.wrapperModules.niri ];
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        binds = {
          "Super+Return".spawn = config.flake.aspects.terminal.emulator;
          "Super+C".close-window = _: { };
          "Super+H".focus-column-left = _: { };
          "Super+J".focus-workspace-down = _: { };
          "Super+K".focus-workspace-up = _: { };
          "Super+L".focus-column-right = _: { };
          "Super+Shift+H".move-column-left = _: { };
          "Super+Shift+J".move-column-to-workspace-down = _: { };
          "Super+Shift+K".move-column-to-workspace-up = _: { };
          "Super+Shift+L".move-column-right = _: { };
          "Super+F".maximize-column = _: { };
          "Super+Shift+F".fullscreen-window = _: { };
          "Super+BracketLeft".consume-or-expel-window-left = _: { };
          "Super+BracketRight".consume-or-expel-window-right = _: { };
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
          skip-at-startup = _: { };
        };
        window-rules = [
          {
            geometry-corner-radius = 20;
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
        ];
      };
    };

  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.noctalia = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
        settings = {
          theme = {
            mode = "dark";
          };
          wallpaper = {
            enabled = true;
            # TODO: Figure out how to set this value based on monitor type
            directory = "${config.home.homeDirectory}/${wallpapers.ultrawide}";
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

  flake.modules.nixos.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      niriWithMonitors = self.wrappers.niri.apply {
        settings.outputs = lib.mapAttrs' (
          _name: m:
          lib.nameValuePair m.connector {
            mode = "${toString m.width}x${toString m.height}@${m.refreshRate}";
          }
        ) config.host.monitors.configs;
      };
    in
    {
      programs.niri = {
        enable = true;
        package = niriWithMonitors.wrap { inherit pkgs; };
      };
      services.displayManager.defaultSession = lib.mkForce "niri";
      services.displayManager.noctalia-greeter = {
        enable = true;
      };
      # TODO: Wait for noctalia-greeter module to be updated to enable the auto-sync feature
      # Doing it manually is a bit janky.
    };
}

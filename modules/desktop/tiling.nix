{
  self,
  inputs,
  lib,
  config,
  ...
}:
{
  # Need to limit what gets built based on system type
  perSystem =
    { pkgs, ... }:
    {
      wrappers.control_type = "exclude";
      wrappers.packages = {
        noctalia = !pkgs.stdenv.isLinux;
        niri = !pkgs.stdenv.isLinux;
      };

    };

  flake.wrappers.noctalia =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };

  flake.wrappers.niri =
    { pkgs, wlib, ... }:
    {
      # By adding the custom noctalia wrapper as an extra package, we ensure
      # niri can access it on the PATH
      runtimePkgs = [
        (self.wrappers.noctalia.wrap { inherit pkgs; })
        pkgs.xwayland-satellite
      ];
      imports = [ wlib.wrapperModules.niri ];
      v2-settings = true;
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
          "Super+Space".spawn-sh = "noctalia-shell ipc call launcher toggle";
        };
        input.keyboard.xkb.layout = "us";
        spawn-at-startup = [ "noctalia-shell" ];
        layout = {
          default-column-width = {
            proportion = 0.5;
          };
        };
        hotkey-overlay = {
          skip-at-startup = _: { };
        };

        window-rules = [
          { draw-border-with-background = false; }
        ];
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
    };

}

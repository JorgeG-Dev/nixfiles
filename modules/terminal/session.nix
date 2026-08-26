{
  self,
  config,
  ...
}:
let
  # herdr has no upstream wrapper module yet, so define one here.
  # It reads a single TOML file whose location is set by HERDR_CONFIG_PATH,
  # which is all a wrapper needs to keep the config out of $HOME.
  herdrModule =
    {
      config,
      lib,
      pkgs,
      wlib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      options.settings = lib.mkOption {
        type = wlib.types.structuredValueWith {
          nullable = false;
          typeName = "TOML";
        };
        default = { };
        description = ''
          Pure nix configuration of herdr's config.toml.
          Run `herdr --default-config` for the annotated reference.
          See <https://herdr.dev/docs/configuration/>
        '';
        example = {
          theme.name = "catppuccin";
        };
      };

      config = {
        package = lib.mkDefault pkgs.herdr;

        constructFiles."config.toml" = {
          relPath = "config.toml";
          content = builtins.toJSON config.settings;
          builder = ''${pkgs.remarshal}/bin/json2toml "$1" "$2"'';
        };

        env.HERDR_CONFIG_PATH = config.constructFiles."config.toml".path;
      };
    };

  # nixos and darwin install the same way, so define the module once
  installModule = {
    imports = [ self.wrappers.herdr.install ];
    wrappers.herdr.enable = true;
  };
in
{
  flake.wrappers.herdr =
    { ... }:
    {
      imports = [ herdrModule ];
      settings = {
        onboarding = false;

        terminal = {
          default_shell = config.flake.aspects.terminal.shell;
          shell_mode = "auto";
          new_cwd = "follow";
        };

        theme = {
          name = "catppuccin";
          auto_switch = false;
        };

        # carried over from tmux: the C-s prefix and vim pane navigation.
        # herdr already defaults to prefix+h/j/k/l, but pin them so an
        # upstream default change can't silently move them.
        keys = {
          prefix = "ctrl+s";
          focus_pane_left = "prefix+h";
          focus_pane_down = "prefix+j";
          focus_pane_up = "prefix+k";
          focus_pane_right = "prefix+l";
        };
      };
    };

  flake.modules.nixos.terminal = installModule;
  flake.modules.darwin.terminal = installModule;
}

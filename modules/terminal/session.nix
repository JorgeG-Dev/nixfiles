{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.wrappers.tmux =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.tmux ];
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          configAfter = ''
            # Configure the catppuccin plugin
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "rounded"

            # Make the status line pretty and add some modules
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -agF status-right "#{E:@catppuccin_status_cpu}"
            set -agF status-right "#{E:@catppuccin_status_ram}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
            set -agF status-right "#{E:@catppuccin_status_battery}"
          '';
        }
      ];
      mouse = true;
      clock24 = true;
      escapeTime = 10;
      prefix = "C-s";
      configAfter = ''
        # vim bindings
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        set -g status-position top
      '';

    };

  flake.modules.nixos.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.tmux.install ];
      wrappers.tmux.enable = true;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.darwin.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.tmux.install ];
      wrappers.tmux.enable = true;
      environment.systemPackages = with pkgs; [
      ];
    };
}

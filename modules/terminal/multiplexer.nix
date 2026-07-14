{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.modules.homeManager.terminal = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        yank
        {
          plugin = catppuccin;
          extraConfig = ''

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
      extraConfig = ''
        set -g mouse on
        set -g prefix C-s
        set -g status-position top
        set -sg escape-time 10

        # vim bindings
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
      '';
    };
  };
}

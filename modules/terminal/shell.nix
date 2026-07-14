{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.aspects.terminal.shell = "zsh";
  flake.wrappers.starship =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.starship ];
      preset = "catppuccin-powerline";
      settings = {
        add_newline = true;
        cmd_duration = {
          disabled = true;
          show_notifications = false;
        };
      };
    };

  flake.wrappers.zsh =
    { pkgs, wlib, ... }:
    {
      config.runtimePkgs = [ (self.wrappers.starship.wrap { inherit pkgs; }) ];
      imports = [ wlib.wrapperModules.zsh ];
      config.zshrc.content = ''
                		# History
                		HISTSIZE=10000
                		SAVEHIST=10000
                		setopt HIST_IGNORE_SPACE SHARE_HISTORY
                		
                		# Completion
                		autoload -U compinit && compinit
        			
                        # Default editor (temporary till neovim is setup)
                        export EDITOR=vim
                		
                		# Starship
                		eval "$(starship init zsh)"
                		'';
    };

  flake.modules.nixos.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.zsh.install ];
      wrappers.zsh.enable = true;
      wrappers.zsh.asSystemDefault = true;
      users.users.${config.flake.aspects.owner.username}.shell = (
        self.wrappers.zsh.wrap { inherit pkgs; }
      );
    };

  flake.modules.darwin.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.zsh.install ];
      wrappers.zsh.enable = true;
      users.users.${config.flake.aspects.owner.username}.shell = (
        self.wrappers.zsh.wrap { inherit pkgs; }
      );
      homebrew.enableZshIntegration = true;
    };

}

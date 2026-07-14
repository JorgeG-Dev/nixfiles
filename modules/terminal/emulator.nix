{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.aspects.terminal.emulator = "ghostty";

  flake.modules.homeManager.terminal = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
      enableZshIntegration = true;
      settings = {
        font-family = config.flake.aspects.fonts.mono;
        font-size = 14;
        background-opacity = 0.9;
        cursor-style = "block";
        confirm-close-surface = false;
        keybind = [
          "ctrl+shift+t=new_tab"
          "ctrl+shift+w=close_tab"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
        ];
      };
    };
  };
}

{ self, ... }:
let
  yaziModule = {
    imports = [ self.wrappers.yazi.install ];
    wrappers.yazi.enable = true;
  };
in
{
  flake.wrappers.yazi =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.yazi ];
      settings = {
        yazi = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
          };
        };
      };
    };

  flake.modules.nixos.terminal = yaziModule;
  flake.modules.darwin.terminal = yaziModule;
}

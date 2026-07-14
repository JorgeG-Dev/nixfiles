{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
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

  flake.modules.nixos.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.yazi.install ];
      wrappers.yazi.enable = true;
    };

  flake.modules.darwin.terminal =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.yazi.install ];
      wrappers.yazi.enable = true;
    };
}

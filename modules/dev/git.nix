{
  self,
  inputs,
  config,
  pkgs,
  wlib,
  ...
}:
{
  flake.wrappers.git =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.git ];
      settings = {
        user = {
          name = config.flake.aspects.owner.name;
          email = config.flake.aspects.owner.email;
        };
      };
    };

  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.git.install ];
      wrappers.git.enable = true;
      environment.systemPackages = with pkgs; [
        lazygit
        git-filter-repo
      ];
    };

  flake.modules.darwin.dev =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.git.install ];
      wrappers.git.enable = true;
      environment.systemPackages = with pkgs; [
        lazygit
        git-filter-repo
      ];
    };
}

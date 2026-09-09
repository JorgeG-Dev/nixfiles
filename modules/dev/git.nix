{ self, config, ... }:
let
  gitModule =
    { pkgs, ... }:
    {
      imports = [ self.wrappers.git.install ];
      wrappers.git.enable = true;
      environment.systemPackages = with pkgs; [
        lazygit
        git-filter-repo
        gh
      ];
    };
in
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

  flake.modules.nixos.dev = gitModule;
  flake.modules.darwin.dev = gitModule;
}

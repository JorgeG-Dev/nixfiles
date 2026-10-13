{ self, config, ... }:
let
  owner = config.flake.aspects.owner;
  gitModule =
    { pkgs, ... }:
    {
      home-manager.users.${owner.username}.imports = [ self.modules.homeManager.dev ];
      environment.systemPackages = with pkgs; [
        lazygit
        git-filter-repo
        gh
        tea
      ];
    };
in
{
  flake.modules.homeManager.dev = {
    programs.git = {
      enable = true;
      settings.user = {
        name = owner.name;
        email = owner.email;
      };
    };
  };

  flake.modules.nixos.dev = gitModule;
  flake.modules.darwin.dev = gitModule;
}

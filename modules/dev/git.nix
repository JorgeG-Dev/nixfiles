{ self, config, ... }:
let
  owner = config.flake.aspects.owner;
  gitModule =
    { pkgs, ... }:
    {
      home-manager.users.${owner.username}.imports = [ self.modules.homeManager.dev ];
      environment.systemPackages = with pkgs; [
        git-filter-repo
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
    programs.lazygit.enable = true;
    programs.gh = {
      enable = true;
      # Remotes here are SSH, so git has no use for gh as an HTTPS credential helper.
      gitCredentialHelper.enable = false;
    };
  };

  flake.modules.nixos.dev = gitModule;
  flake.modules.darwin.dev = gitModule;
}

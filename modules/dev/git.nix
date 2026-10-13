{ self, config, ... }:
let
  owner = config.flake.aspects.owner;
  gitModule =
    { pkgs, ... }:
    {
      home-manager.users.${owner.username}.imports = [ self.modules.homeManager.dev ];
      environment.systemPackages = with pkgs; [
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
    # Sets git's core.pager and interactive.diffFilter to delta.
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options.navigate = true;
    };
    programs.lazygit = {
      enable = true;
      # lazygit can't let delta page or probe the terminal background itself.
      settings.git.diffRenderers = [
        {
          colorArg = "always";
          command = "delta --dark --paging=never";
        }
      ];
    };
    programs.gh = {
      enable = true;
      # Remotes here are SSH, so git has no use for gh as an HTTPS credential helper.
      gitCredentialHelper.enable = false;
    };
  };

  flake.modules.nixos.dev = gitModule;
  flake.modules.darwin.dev = gitModule;
}

{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules = {
    nixos.core = {
      users.users.${config.flake.aspects.owner.username} = {
        isNormalUser = true;
        initialPassword = "12345";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };
      nix.settings.trusted-users = [ config.flake.aspects.owner.username ];
      home-manager.users.${config.flake.aspects.owner.username} = {
        home.username = config.flake.aspects.owner.username;
        home.homeDirectory = "/home/${config.flake.aspects.owner.username}";
        systemd.user.startServices = "sd-switch";
        imports = [
          inputs.self.modules.homeManager.core
          inputs.self.modules.homeManager.desktop
          inputs.self.modules.homeManager.terminal
        ];
      };
    };

    darwin.core = {

      # For some reason, home manager on darwin doesn't play nice with home.homeDirectory and home.username
      # Setting them here seems to work according to this issue:
      # https://github.com/nix-community/home-manager/issues/6036
      users.users.${config.flake.aspects.owner.username} = {
        home = "/Users/${config.flake.aspects.owner.username}";
        name = config.flake.aspects.owner.username;
      };
      system.primaryUser = config.flake.aspects.owner.username;
      nix.settings.trusted-users = [ config.flake.aspects.owner.username ];
      security.pam.services.sudo_local.touchIdAuth = true;
      home-manager.users.${config.flake.aspects.owner.username} = {
        imports = [
          inputs.self.modules.homeManager.core
          inputs.self.modules.homeManager.desktop
          inputs.self.modules.homeManager.terminal
        ];
      };
    };
  };
}

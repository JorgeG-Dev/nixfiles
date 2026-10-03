{ config, ... }:
let
  owner = config.flake.aspects.owner.username;

  # Keys allowed to log into the NixOS hosts as the owner.
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL42vvXY/XcRI5bKxjeLHQYL5iWNmMXPFY0oYMBhWNiI"
  ];
in
{
  flake.modules.nixos.core = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ owner ];
      };
    };
    users.users.${owner}.openssh.authorizedKeys.keys = authorizedKeys;
  };

  # Keeps macOS Remote Login off.
  flake.modules.darwin.core = {
    services.openssh.enable = false;
  };

  flake.modules.homeManager.core = {
    programs.ssh = {
      enable = true;
      # The implicit "*" block is deprecated; OpenSSH's own defaults match it.
      enableDefaultConfig = false;
      # Unmanaged, per-machine hosts that shouldn't live in a public repo.
      includes = [ "config.local" ];
      settings = {
        "github.com" = {
          User = "git";
          IdentityFile = "~/.ssh/github";
          IdentitiesOnly = true;
        };
        "git.lan" = {
          User = "git";
          Port = 222;
          IdentityFile = "~/.ssh/forgejo";
          IdentitiesOnly = true;
        };
        "little-ghost" = {
          HostName = "little-ghost.lan";
          User = owner;
          IdentityFile = "~/.ssh/little-ghost";
          IdentitiesOnly = true;
        };
      };
    };
  };
}

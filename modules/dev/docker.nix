{
  self,
  inputs,
  config,
  pkgs,
  ...
}:
{
  flake.modules.nixos.dev = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    users.users.${config.flake.aspects.owner.username}.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      docker-compose
      docker-buildx
    ];
  };
}

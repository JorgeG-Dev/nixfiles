{ inputs, config, ... }:
{
  # TODO: Fill out SSH key stuff for both systems
  flake.modules.nixos.core = {
    services.openssh.enable = false;
  };

  flake.modules.darwin.core = {
    services.openssh.enable = false;
  };
}

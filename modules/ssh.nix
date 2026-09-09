{ ... }:
let
  # TODO: Fill out SSH key stuff for both systems
  sshModule = {
    services.openssh.enable = false;
  };
in
{
  flake.modules.nixos.core = sshModule;
  flake.modules.darwin.core = sshModule;
}

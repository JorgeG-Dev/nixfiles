{ ... }:
let
  aiModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
      ];
    };
in
{
  flake.modules.nixos.dev = aiModule;
  flake.modules.darwin.dev = aiModule;
}

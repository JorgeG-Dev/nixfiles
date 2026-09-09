{ ... }:
let
  # Both platforms install the same font set.
  fontsModule =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
in
{
  flake.aspects.fonts.mono = "JetBrainsMono Nerd Font";

  flake.modules.darwin.core = fontsModule;
  flake.modules.nixos.core = fontsModule;
}

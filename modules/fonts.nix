{ inputs, config, ... }:
{
  flake.aspects.fonts.mono = "JetBrainsMono Nerd Font";

  flake.modules.darwin.core =
    { pkgs, ... }:
    {
      system.defaults.NSGlobalDomain = {
        AppleMeasurementUnits = "Inches";
      };
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

    };
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
}

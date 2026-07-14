{ inputs, config, ... }:
{
  flake.modules.nixos.core = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    system.stateVersion = "25.11";
  };
  flake.modules.darwin.core = {
    nix.enable = false;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
    system.stateVersion = 6;
  };
}

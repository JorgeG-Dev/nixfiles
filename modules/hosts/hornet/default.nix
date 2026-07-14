{ inputs, ... }:
{
  flake.darwinConfigurations.hornet = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = with inputs.self.modules.darwin; [
      hornet
      dev
      terminal
      core
      desktop
      gaming
    ];
  };
}

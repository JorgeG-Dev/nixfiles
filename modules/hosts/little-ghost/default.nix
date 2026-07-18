{ inputs, ... }:
{
  flake.nixosConfigurations.little-ghost = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [
      little-ghost
      core
      desktop
      dev
      terminal
    ];
  };
}

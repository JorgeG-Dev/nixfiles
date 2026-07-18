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
      inputs.preservation.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.self.diskoConfigurations.little-ghost
    ];
  };
}

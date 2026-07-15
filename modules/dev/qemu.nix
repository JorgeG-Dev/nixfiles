{
  self,
  inputs,
  config,
  pkgs,
  ...
}:
{
  flake.modules.nixos.dev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}

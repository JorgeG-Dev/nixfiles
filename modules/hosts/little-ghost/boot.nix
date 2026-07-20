{
  inputs,
  config,
  pkgs,
  ...
}:
{
  flake.modules.nixos.little-ghost =
    { pkgs, ... }:
    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "uas"
        "sd_mod"
      ];
      environment.systemPackages = with pkgs; [
        sbctl
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.loader.systemd-boot.enable = false;
      boot.loader.limine.enable = true;
      boot.loader.limine.secureBoot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };
}

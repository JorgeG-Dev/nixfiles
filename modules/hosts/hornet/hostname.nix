{ ... }:
{
  flake.modules.darwin.hornet = {
    networking.hostName = "hornet";
    networking.computerName = "MacBook Pro";
  };
}

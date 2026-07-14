{
  inputs,
  config,
  lib,
  ...
}:
{
  # Meant to be more of a metadata module, just declaring information about the owner of the system
  flake = {
    aspects.owner = {
      email = "jgomezmail-dev@proton.me";
      name = "Jorge Gomez";
      username = "jorge";
    };
  };
}

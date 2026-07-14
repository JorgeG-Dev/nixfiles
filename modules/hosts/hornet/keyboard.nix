{ inputs, config, ... }:
{
  flake.modules.darwin.hornet = {
    system.defaults.NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      ApplePressAndHoldEnabled = false;
    };
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;
  };
}

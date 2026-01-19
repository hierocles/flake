{
  flake.aspects.firmware.nixos = {
    services.fwupd.enable = true;
    hardware.enableAllFirmare = true;
    hardware.enableRedistributableFirmware = true;
  };
}

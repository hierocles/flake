{
  flake.aspects.bootloader.nixos = {
    boot.loader = {
      systemd-boot.enable = true;
      grub.enable = false;
    };
  };
}

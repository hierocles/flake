_: {
  flake.aspects.server._.hardware = {
    nixos = {pkgs, ...}: {
      # Required for ZFS - generate with: head -c 8 /etc/machine-id
      networking.hostId = "01749328";
      system.boot = {
        enable = true;
        efi = true;
      };

      system.zfs = {
        enable = true;
        hostId = "01749328";
      };

      hardware.cpu.intel.updateMicrocode = true;
      boot.kernelParams = ["i915.enable_guc=2"];
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver
          intel-media-driver
          vpl-gpu-rt
        ];
      };
    };
  };
}

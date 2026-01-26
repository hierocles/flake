_: {
  flake.aspects.server._.hardware = {
    nixos = {pkgs, ...}: {
      # Required for ZFS - generate with: head -c 8 /etc/machine-id
      networking.hostId = "01749328";

      boot = {
        loader.efi.canTouchEfiVariables = true;
        kernelParams = ["i915.enable_guc=2"];
        supportedFilesystems = [
          "zfs"
          "btrfs"
        ];
      };

      services.zfs = {
        autoScrub.enable = true;
        autoSnapshot.enable = true;
      };

      hardware = {
        cpu.intel.updateMicrocode = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-vaapi-driver
            intel-media-driver
            vpl-gpu-rt
          ];
        };
      };
    };
  };
}

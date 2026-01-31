{inputs, ...}: {
  flake.aspects.server._.disks = {
    nixos = {lib, ...}: let
      flakeLib = inputs.self.lib;
    in {
      # Disk Layout:
      # - NVMe drive: 1.9TB BTRFS for NixOS system (managed by disko)
      # - ZFS pool "media": 4x10TB HDDs in striped mirror (NOT managed by disko)

      disko.devices = flakeLib.mkBtrfsDiskLayout {
        swapsize = 32; # 32GB swap
        device = "/dev/disk/by-id/nvme-TEAM_TM8FP6002T_TPBF2312080030304554";
      };

      # Override /home mount options to remove erroneous 'bind' option from disko
      fileSystems."/home".options = lib.mkForce [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=home"
      ];

      boot.zfs.extraPools = ["media"];

      fileSystems."/mnt/media" = {
        device = "media";
        fsType = "zfs";
        options = ["zfsutil" "nofail" "x-systemd.requires=zfs-import.target"];
      };
    };
  };
}

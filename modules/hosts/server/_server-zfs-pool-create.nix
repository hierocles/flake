# BACKUP: ZFS Pool Creation Config for disko
# This file is NOT used in the normal configuration.
# Use this with disko to CREATE the ZFS pool from scratch on a new system.
#
# Usage (to create pool on fresh disks):
#   nix run github:nix-community/disko -- --mode disko ./modules/hosts/server/disks-zfs-create.nix
#
# WARNING: This will DESTROY all data on the specified drives!
{inputs, ...}: let
  inherit (inputs.self) lib;
in {
  disko.devices = lib.mkStripedMirrorZfsLayout {
    vdevs = [
      # First mirror vdev (sda + sdb)
      {
        sda = "/dev/disk/by-id/ata-HGST_HUH721010ALE604_2YG8V7HD";
        sdb = "/dev/disk/by-id/ata-HGST_HUH721010ALE604_2TKWWHSD";
      }
      # Second mirror vdev (sdc + sdd)
      {
        sdc = "/dev/disk/by-id/ata-HUH721010ALE601_7JJ10PVC";
        sdd = "/dev/disk/by-id/ata-HGST_HUH721010ALE604_2YGE5SRD";
      }
    ];
    poolName = "media";
    mountpoint = "/mnt/media";
    datasetOptions = {
      # Disable automatic snapshots for media storage
      "com.sun:auto-snapshot" = "false";

      # Compression - lz4 is fast and provides good compression for media files
      compression = "lz4";

      # Disable access time updates for better performance
      atime = "off";

      # Use larger record sizes for better sequential I/O (ideal for media files)
      recordsize = "1M";

      # Optimize for sequential access patterns (media streaming)
      primarycache = "metadata";

      # Disable deduplication (not useful for media files and uses lots of RAM)
      dedup = "off";

      # Set reasonable sync behavior for better performance
      sync = "standard";

      # Optimize for large files (media content)
      logbias = "throughput";
    };
  };
}

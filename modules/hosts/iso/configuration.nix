{
  inputs,
  lib,
  ...
}: {
  flake.aspects = {aspects, ...}: {
    iso = {
      description = "NixOS installer ISO image";
      includes = with aspects; [
        system-defaults
        constants
        iso._.packages
      ];

      nixos = {pkgs, ...}: {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
        ];

        # ISO image settings
        isoImage = {
          isoName = lib.mkDefault "nixos-installer.iso";
          volumeID = lib.mkDefault "NIXOS_ISO";
          makeEfiBootable = true;
          makeUsbBootable = true;
        };

        # Enable SSH for remote installation
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };

        # Set a temporary root password for installation (change this!)
        users.users.root.initialHashedPassword = "";

        # Enable experimental features
        nix.settings.experimental-features = ["nix-command" "flakes"];

        # Networking
        networking = {
          hostName = "nixos-installer";
          useDHCP = lib.mkDefault true;
          wireless.enable = lib.mkDefault false;
          networkmanager.enable = lib.mkDefault true;
        };

        # Console settings
        console = {
          font = "Lat2-Terminus16";
          keyMap = lib.mkDefault "us";
        };

        # Timezone
        time.timeZone = lib.mkDefault "UTC";
      };
    };

    # Installer packages
    iso._.packages = {
      nixos = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          # Disk partitioning
          parted
          gptfdisk
          dosfstools
          e2fsprogs
          btrfs-progs
          xfsprogs

          # Filesystem tools
          ntfs3g
          cryptsetup

          # Network tools
          curl
          wget
          git

          # Editors
          vim
          nano

          # System tools
          htop
          tmux
          pciutils
          usbutils
          lshw

          # Nix tools
          nixos-install-tools
        ];
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "iso";
}

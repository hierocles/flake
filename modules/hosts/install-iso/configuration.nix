{
  inputs,
  lib,
  ...
}: {
  flake.aspects = {aspects, ...}: {
    install-iso = {
      description = "NixOS installation ISO with disko btrfs support";
      includes = with aspects; [
        system-defaults
        constants
        disko
        install-iso._.packages
        install-iso._.install-script
      ];

      nixos = {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
        ];

        # ISO image settings
        image.fileName = lib.mkDefault "nixos-btrfs-installer.iso";
        isoImage = {
          volumeID = lib.mkDefault "NIXOS_INSTALL";
          makeEfiBootable = true;
          makeUsbBootable = true;
        };

        # Configure disko with the btrfs layout (placeholder device)
        # The actual device will be specified at install time
        disko.devices = inputs.self.lib.mkBtrfsDiskLayout {
          swapsize = 32;
          # Placeholder - will be overridden during installation
          device = "/dev/disk/by-id/PLACEHOLDER";
        };

        # Enable SSH for remote installation
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };

        # Set empty root password for installation
        users.users.root.initialHashedPassword = "";

        # Enable flakes
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

        time.timeZone = lib.mkDefault "UTC";

        # Include the flake in the ISO for offline installation
        environment.etc."nixos-flake".source = inputs.self;

        # Include extra-files (SSH host keys, etc.) in the ISO
        # These will be copied to /mnt during installation
        environment.etc."extra-files".source = ../../../extra-files;
      };
    };

    # Packages for the installer
    install-iso._.packages = {
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
          nvme-cli

          # Nix tools
          nixos-install-tools
        ];
      };
    };

    # Installation script
    install-iso._.install-script = {
      nixos = {pkgs, ...}: let
        install-nixos = pkgs.writeShellScriptBin "install-nixos" ''
          set -euo pipefail

          # Colors for output
          RED='\033[0;31m'
          GREEN='\033[0;32m'
          YELLOW='\033[1;33m'
          NC='\033[0m' # No Color

          echo -e "''${GREEN}=== NixOS BTRFS Installation Script ===''${NC}"
          echo ""

          # Check if running as root
          if [[ ''$EUID -ne 0 ]]; then
            echo -e "''${RED}This script must be run as root''${NC}"
            exit 1
          fi

          # List available disks
          echo -e "''${YELLOW}Available disks:''${NC}"
          echo ""
          lsblk -d -o NAME,SIZE,MODEL,SERIAL | grep -v "loop\|sr\|rom"
          echo ""
          echo -e "''${YELLOW}Disk IDs (recommended for stable naming):''${NC}"
          ls -la /dev/disk/by-id/ | grep -v "part\|wwn\|lvm" | tail -n +2
          echo ""

          # Get disk from user
          read -p "Enter the disk device (e.g., /dev/disk/by-id/nvme-...): " DISK

          if [[ ! -e "''$DISK" ]]; then
            echo -e "''${RED}Error: Disk ''$DISK does not exist''${NC}"
            exit 1
          fi

          echo ""
          echo -e "''${RED}WARNING: This will ERASE ALL DATA on ''$DISK''${NC}"
          read -p "Are you sure you want to continue? (yes/no): " CONFIRM

          if [[ "''$CONFIRM" != "yes" ]]; then
            echo "Installation cancelled."
            exit 0
          fi

          # Get the flake URI
          FLAKE_PATH="/etc/nixos-flake"
          if [[ -d "''$FLAKE_PATH" ]]; then
            echo -e "''${GREEN}Using bundled flake from ISO''${NC}"
            FLAKE_URI="''$FLAKE_PATH"
          else
            read -p "Enter flake URI (e.g., github:user/repo or /path/to/flake): " FLAKE_URI
          fi

          # Get the configuration name
          read -p "Enter NixOS configuration name [server]: " CONFIG_NAME
          CONFIG_NAME=''${CONFIG_NAME:-server}

          # Check for extra-files directory (SSH host keys, etc.)
          # Default to bundled extra-files if available
          EXTRA_FILES=""
          if [[ -d "/etc/extra-files" ]]; then
            EXTRA_FILES="/etc/extra-files"
            echo ""
            echo -e "''${GREEN}Found bundled extra-files (SSH host keys, etc.)''${NC}"
          else
            echo ""
            echo -e "''${YELLOW}Extra files (SSH host keys, secrets, etc.):''${NC}"
            echo "If you have an extra-files directory with files to copy to the system"
            echo "(e.g., /mnt/usb/extra-files with etc/ssh/ssh_host_ed25519_key),"
            echo "enter the path now. The directory structure should mirror the target."
            echo ""
            read -p "Extra files path (leave empty to skip): " EXTRA_FILES
          fi

          echo ""
          echo -e "''${YELLOW}Installation Summary:''${NC}"
          echo "  Disk: ''$DISK"
          echo "  Flake: ''$FLAKE_URI"
          echo "  Configuration: ''$CONFIG_NAME"
          if [[ -n "''$EXTRA_FILES" ]]; then
            echo "  Extra files: ''$EXTRA_FILES"
          fi
          echo ""
          read -p "Press Enter to start installation or Ctrl+C to cancel..."

          echo ""
          echo -e "''${GREEN}Running disko to partition and format disk...''${NC}"

          # Run disko with the disk override
          ${pkgs.disko}/bin/disko \
            --mode disko \
            --flake "''$FLAKE_URI#''$CONFIG_NAME" \
            --disk nvme "''$DISK"

          # Copy extra files if provided (SSH host keys, etc.)
          if [[ -n "''$EXTRA_FILES" && -d "''$EXTRA_FILES" ]]; then
            echo ""
            echo -e "''${GREEN}Copying extra files to /mnt...''${NC}"
            cp -rv "''$EXTRA_FILES"/* /mnt/
            # Fix SSH key permissions
            if [[ -f /mnt/etc/ssh/ssh_host_ed25519_key ]]; then
              chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
              chmod 644 /mnt/etc/ssh/ssh_host_ed25519_key.pub 2>/dev/null || true
              echo -e "''${GREEN}SSH host keys installed''${NC}"
            fi
          fi

          echo ""
          echo -e "''${GREEN}Installing NixOS...''${NC}"

          # Install NixOS
          nixos-install --flake "''$FLAKE_URI#''$CONFIG_NAME" --no-root-passwd

          echo ""
          echo -e "''${GREEN}=== Installation Complete! ===''${NC}"
          echo ""
          echo "You can now reboot into your new NixOS system."
          echo "Run 'reboot' when ready."
        '';
      in {
        environment.systemPackages = [install-nixos];
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "install-iso";
}

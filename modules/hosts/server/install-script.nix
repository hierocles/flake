{pkgs, ...}: {
  flake.aspects.server._.install-script = {
    nixos = {...}: {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "bootstrap-server" ''
          set -e

          echo "🚀 Starting NixOS Installation..."

          if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
            echo "❌ Error: Host key not found at /etc/ssh/ssh_host_ed25519_key"
            echo "Run this from your local machine first:"
            echo "scp ./ssh_host_ed25519_key root@$(hostname -I | awk '{print $1}'):/etc/ssh/"
            exit 1
          fi

          echo "🔧 Fixing key permissions..."
          chmod 600 /etc/ssh/ssh_host_ed25519_key

          nix run github:nix-community/disko -- --mode destroy,format,mount \
            --flake "github:hierocles/flake#server"

          echo "❄️ Installing NixOS..."
          nixos-install --flake "github:hierocles/flake#server" --no-root-passwd

          echo "✅ Done! You can now reboot."
        '')
      ];
    };
  };
}

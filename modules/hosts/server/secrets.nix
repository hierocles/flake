{inputs, ...}: {
  flake.aspects.server._.secrets = {
    nixos = {
      sops = {
        defaultSopsFile = "${inputs.secrets.outPath}/secrets.yaml";
        validateSopsFiles = false;

        age = {
          sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
          #keyFile = "/var/lib/sops-nix/key.txt";
          #generateKey = true;
        };

        secrets = {
          "vpn/wgconf" = {
            mode = "0644";
            path = "/var/lib/secrets/wireguard/wg0.conf";
            owner = "root";
          };
        };
      };
    };
  };
}

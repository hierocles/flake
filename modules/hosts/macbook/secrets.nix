{inputs, ...}: {
  flake.aspects.macbook._.secrets = {
    darwin = {
      sops = {
        defaultSopsFile = "${inputs.secrets.outPath}/secrets.yaml";
        validateSopsFiles = false;

        age = {
          sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };

        secrets = {};
      };
    };
  };
}

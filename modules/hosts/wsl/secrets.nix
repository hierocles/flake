{inputs, ...}: let
  secretsPath = toString inputs.secrets;
in {
  flake.aspects.wsl._.secrets = {
    nixos = {
      sops = {
        defaultSopsFile = "${secretsPath}/secrets.yaml";
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

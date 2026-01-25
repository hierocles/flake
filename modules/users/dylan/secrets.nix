{inputs, ...}: let
  secretsPath = toString inputs.secrets;
in {
  flake.aspects.dylan._.secrets = {
    homeManager = {config, ...}: {
      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = "${secretsPath}/secrets.yaml";
        secrets = {
          "private_keys/dylan" = {
            path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          };
        };
      };
    };
  };
}

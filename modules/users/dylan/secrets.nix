{inputs, ...}: {
  flake.aspects.dylan._.secrets = {
    # NixOS-level secrets (for hashedPasswordFile, etc.)
    nixos = {config, ...}: {
      sops = {
        defaultSopsFile = "${inputs.secrets}/secrets.yaml";
        secrets."passwords/dylan".neededForUsers = true;
        secrets."passwords/root".neededForUsers = true;
      };
      users.users.root.hashedPasswordFile = config.sops.secrets."passwords/root".path;
    };

    # Home-manager secrets (for SSH keys, etc.)
    homeManager = {config, ...}: {
      home.file.".config/sops/age/keys.txt".source = inputs.secrets.age-key-path;
      home.activation.fixSopsKeyPermissions = config.lib.dag.entryAfter ["writeBoundary"] ''
        chmod 600 ${config.home.homeDirectory}/.config/sops/age/keys.txt
      '';
      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = "${inputs.secrets}/secrets.yaml";
        secrets."private_keys/dylan" = {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          mode = "0400";
        };
      };
    };
  };
}

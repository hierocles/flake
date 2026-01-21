{
  flake.aspects.dylan._.ssh = let
    pubKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIehGIKQ4+hq6gNyqDGomjTf4ScKrbMLBRbdD+lhbc2Y"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGORDdMJO2zmxGOUJp5qTIgs7dRbTqmUA/dsf4xSxo1+ openpgp:0x493E86BD"
    ];
  in {
    nixos = {
      users.users.dylan.openssh.authorizedKeys.keys = pubKeys;
    };
    darwin = {
      users.users.dylan.openssh.authorizedKeys.keys = pubKeys;
    };
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "auto";
            controlPath = "~/.ssh/sockets/master-%r@%h:%p";
            controlPersist = "300s";
          };
        };
      };

      services.ssh-agent.enable = true;
    };
  };
}

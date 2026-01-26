{
  flake.aspects.server._.networking = {
    nixos = {config, ...}: {
      networking = {
        enableIPv6 = false;
        interfaces = {
          enp3s0 = {
            ipv4.addresses = {
              address = config.sops.secrets.networking.subnets.server.ip;
              prefixLength = 24;
            };
          };
        };
        firewall.enable = true;
        defaultGateway = {
          address = config.sops.secrets.networking.defaultGateway;
          interface = "enp3s0";
        };
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };
}

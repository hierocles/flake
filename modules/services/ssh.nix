{
  flake.aspects.ssh = {
    nixos = {
      services.openssh = {
        enable = true;
        ports = [2222]; # Needs to be different than endlessh
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };
      services.fail2ban.enable = true;
      services.endlessh = {
        enable = true;
        port = 22;
        openFirewall = true;
      };
    };
  };
}

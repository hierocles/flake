{
  flake.aspects.ssh = {
    nixos = {
      services.openssh = {
        enable = true;
        ports = [22];
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

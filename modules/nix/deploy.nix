{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs.deploy-rs = {
    url = "github:serokell/deploy-rs";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.nixos-anywhere = {
    url = "github:nix-community/nixos-anywhere";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Deploy configurations for each host
  flake.deploy = lib.mkIf (inputs ? deploy-rs) {
    # Use local node for building
    remoteBuild = false;

    nodes = {
      server = {
        hostname = "server";
        profiles.system = {
          user = "root";
          sshUser = "dylan";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.server;
        };
      };
    };
  };

  # Add deploy-rs checks
  perSystem = {system, ...}: {
    checks = lib.mkIf (inputs ? deploy-rs) (
      inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy
    );

    packages = lib.mkMerge [
      # Make deploy-rs available in devshell
      (lib.mkIf (inputs ? deploy-rs) {
        deploy-rs = inputs.deploy-rs.packages.${system}.default;
      })

      # Make nixos-anywhere available in devshell
      (lib.mkIf (inputs ? nixos-anywhere) {
        nixos-anywhere = inputs.nixos-anywhere.packages.${system}.default;
      })
    ];
  };
}

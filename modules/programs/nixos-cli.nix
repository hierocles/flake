{
  inputs,
  self,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixos-cli.url = "github:nix-community/nixos-cli";
  };

  flake.aspects.cli.nixos = {
    imports = lib.optionals (inputs ? nixos-cli) [
      inputs.nixos-cli.nixosModules.nixos-cli
    ];

    services.nixos-cli = {
      enable = true;
      config = {
        general = {
          config_location = "${self}";
          root_command = "doas";
          use_nvd = true;
        };
        apply = {
          ignore_dirty_tree = true;
          use_nom = true;
        };
        confirmation = {
          empty = "default-yes";
          always = true;
        };
      };
    };
  };
}

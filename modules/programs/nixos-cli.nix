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

    programs.nixos-cli = {
      enable = true;
      settings = {
        general = {
          config_location = "${self}";
        };
        apply = {
          ignore_dirty_tree = true;
          reexec_as_root = true;
          use_nom = true;
        };
        confirmation = {
          empty = "default-yes";
          always = true;
        };
        differ = {
          command = ["nvd" "diff"];
          tool = "command";
        };
        root = {
          command = "doas";
        };
      };
    };
  };
}

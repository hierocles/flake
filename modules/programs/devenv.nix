{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = lib.optionals (inputs ? devenv) [inputs.devenv.flakeModule];

  flake.aspects.devenv =
    if (inputs ? devenv && inputs.devenv ? shells)
    then let
      defaultShell = inputs.devenv.shells.default {
      claude.code.enable = true;
      delta.enable = true;
      difftastic.enable = true;
      treefmt = {
        enable = true;
        config.programs = {
          alejandra.enable = true;
          prettier.enable = true;
          ruff.enable = true;
          eslint.enable = true;
          black.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };
      git-hooks.hooks = {
        tree-fmt.enable = true;
      };
      starship = {
        enable = true;
        config = {
          enable = true;
          settings = {
            command_timeout = 10000;
            add_newline = true;
            format = ''
              [](red)\
              $os\
              $username\
              $localip\
              [](bg:peach fg:red)\
              $directory\
              [](bg:yellow fg:peach)\
              $git_branch\
              $git_status\
              [](fg:yellow bg:green)\
              $nodejs\
              $python\
              [](fg:green bg:sapphire)\
              $nix-shell\
              [](fg:sapphire bg:sky)\
              $docker_context
              [](fg:sapphire bg:lavender)\
              $time\
              [ ](fg:lavender)\
              $cmd_duration\
              $line_break\
              $character
            '';
            palette = "catppuccin-mocha";
            localid = {
              disabled = false;
              ssh_only = true;
              style = "bg:red fg:crust";
              format = "@[$localipv4]($style)";
            };
            os = {
              disabled = false;
              style = "bg:red fg:crust";
            };
            os.symbols = {
              Macos = "󰀵";
              Nixos = "";
            };
            username = {
              show_always = true;
              style_user = "bg:red fg:crust";
              style_root = "bg:red fg:crust";
              format = "[ $user]($style)";
            };
            directory = {
              style = "bg:peach fg:crust";
              format = "[ $path ]($style)";
              truncation_length = 3;
              truncation_symbol = "…/";
            };
            directory.substitutions = {
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Music" = "󰝚 ";
              "Pictures" = " ";
              "Developer" = "󰲋 ";
            };
            git_branch = {
              style = "bg:yellow";
              symbol = " ";
              format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
            };
            git_status = {
              style = "bg:yellow";
              format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
            };
            nodejs = {
              style = "bg:green";
              symbol = " ";
              format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
            };
            python = {
              symbol = "";
              style = "bg:green";
              format = "[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)";
            };
            docker_context = {
              symbol = "";
              style = "bg:sapphire";
              format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
            };
            nix_shell = {
              disabled = false;
              symbol = "";
              style = "bg:sapphire";
              impure_msg = "impure";
              pure_msg = "pure";
              unknown_msg = "unknown";
              format = "[[ $symbol( $state) ](fg:crust bg:sapphire)]($style)";
            };
            time = {
              disabled = false;
              time_format = "%R";
              style = "bg:lavender";
              format = "[[  $time ](fg:crust bg:lavender)]($style)";
            };
            line_break.disabled = true;
            character = {
              disabled = false;
              success_symbol = "[❯](bold fg:green)";
              error_symbol = "[❯](bold fg:red)";
              vimcmd_symbol = "[❮](bold fg:green)";
              vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
              vimcmd_replace_symbol = "[❮](bold fg:lavender)";
              vimcmd_visual_symbol = "[❮](bold fg:yellow)";
            };
            cmd_duration = {
              show_milliseconds = true;
              format = " in $duration ";
              style = "bg:lavender";
              disabled = false;
              show_notifications = true;
              min_time_to_notify = 45000;
            };
            palettes.catppuccin-mocha = {
              rosewater = "#f5e0dc";
              flamingo = "#f2cdcd";
              pink = "#f5c2e7";
              mauve = "#cba6f7";
              red = "#f38ba8";
              maroon = "#eba0ac";
              peach = "#fab387";
              yellow = "#f9e2af";
              green = "#a6e3a1";
              teal = "#94e2d5";
              sky = "#89dceb";
              sapphire = "#74c7ec";
              blue = "#89b4fa";
              lavender = "#b4befe";
              text = "#cdd6f4";
              subtext1 = "#bac2de";
              subtext0 = "#a6adc8";
              overlay2 = "#9399b2";
              overlay1 = "#7f849c";
              overlay0 = "#6c7086";
              surface2 = "#585b70";
              surface1 = "#45475a";
              surface0 = "#313244";
              base = "#1e1e2e";
              mantle = "#181825";
              crust = "#11111b";
            };
          };
        };
      };
    };
    in {
      nixos = defaultShell // {};
      darwin = defaultShell // {};
    }
    else {};
}

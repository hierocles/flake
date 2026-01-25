_: {
  flake.aspects.dylan._.ide = {
    homeManager = {
      pkgs,
      osConfig,
      self,
      ...
    }: let
      flake = "(builtins.getFlake \"${self}\")";
      system = "${flake}.nixosConfigurations.${osConfig.networking.hostName}";
      home = "${system}.options.home-manager.users.type";
    in {
      # Sync Nix-managed VS Code extensions to .vscode-server for Remote WSL
      home.activation.syncVscodeExtensions = {
        after = ["writeBoundary"];
        before = [];
        data = ''
          if [[ -d "$HOME/.vscode/extensions" ]]; then
            run mkdir -p "$HOME/.vscode-server/extensions"

            # Remove stale Nix-managed symlinks (point to /nix/store but no longer in source)
            for target_path in "$HOME/.vscode-server/extensions"/*; do
              [[ -e "$target_path" ]] || continue
              ext_name=$(basename "$target_path")
              [[ "$ext_name" == "extensions.json" || "$ext_name" == ".extensions-immutable.json" ]] && continue
              # Only clean up symlinks pointing to Nix store (not manual installs)
              if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == /nix/store/* ]]; then
                if [[ ! -e "$HOME/.vscode/extensions/$ext_name" ]]; then
                  run rm "$target_path"
                fi
              fi
            done

            # Sync current extensions
            for ext_path in "$HOME/.vscode/extensions"/*; do
              ext_name=$(basename "$ext_path")
              [[ "$ext_name" == "extensions.json" || "$ext_name" == ".extensions-immutable.json" ]] && continue
              target_path="$HOME/.vscode-server/extensions/$ext_name"
              real_path=$(readlink -f "$ext_path" 2>/dev/null || echo "$ext_path")
              if [[ -L "$target_path" ]]; then
                existing=$(readlink -f "$target_path" 2>/dev/null || true)
                [[ "$existing" == "$real_path" ]] && continue
                run rm "$target_path"
              elif [[ -e "$target_path" ]]; then
                continue
              fi
              run ln -s "$real_path" "$target_path"
            done

            # Update extensions.json with correct paths for .vscode-server
            if [[ -f "$HOME/.vscode/extensions/extensions.json" ]]; then
              run ${pkgs.gnused}/bin/sed 's|/.vscode/extensions/|/.vscode-server/extensions/|g' \
                "$HOME/.vscode/extensions/extensions.json" > "$HOME/.vscode-server/extensions/extensions.json"
            fi
          fi

          # Sync settings to .vscode-server for Remote WSL
          if [[ -f "$HOME/.config/Code/User/settings.json" ]]; then
            run mkdir -p "$HOME/.vscode-server/data/Machine"
            run rm -f "$HOME/.vscode-server/data/Machine/settings.json"
            run cp "$HOME/.config/Code/User/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"
          fi
        '';
      };

      programs.vscode.profiles.default = {
        userSettings = {
          "workbench.startupEditor" = "none";
          "workbench.welcomePage.walkthroughs.openOnInstall" = false;
          "workbench.settings.editor" = "json";
          "update.mode" = "none";
          "extensions.ignoreRecommendations" = true;
          "extensions.autoUpdate" = false;
          "extensions.autoCheckUpdates" = false;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
          "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = ["${pkgs.alejandra}/bin/alejandra"];
              };
              "nixpkgs" = {
                "expr" = "import ${flake}.inputs.nixpkgs {}";
              };
              "options" = {
                "nixos" = {
                  "expr" = "${system}.options";
                };
                "home-manager" = {
                  "expr" = "${home}.getSubOptions []";
                };
                "darwin" = {
                  "expr" = "${flake}.darwinConfigurations.macbook.options";
                };
              };
            };
          };
          "nix.hiddenLanguageServerErrors" = [
            "textDocument/definition"
            "textDocument/documentSymbol"
            "textDocument/formatting"
          ];
          "claudeCode.initialPermissionMode" = "acceptEdits";
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 2000;
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = "active";
          "editor.wordWrap" = "wordWrapColumn";
          "editor.wordWrapColumn" = 100;

          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmDelete" = false;

          "claudeCode.preferredLocation" = "panel";
          "claudeCode.disableLoginPrompt" = true;

          "editor.aiStats.enabled" = true;
          "editor.autoIndentOnPaste" = true;
          "editor.codeActions.triggerOnFocusChange" = true;
          "editor.scrollbar.horizontal" = "hidden";
          "editor.unfoldOnClickAfterEndOfLine" = true;
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
          "diffEditor.codeLens" = true;
          "diffEditor.experimental.showMoves" = true;
          "diffEditor.experimental.useTrueInlineView" = true;

          "files.useExperimentalFileWatcher" = true;
          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/.direnv/**" = true;
            "**/result/**" = true;
            "**/.vscode-server/**" = true;
          };
          "files.exclude" = {
            "**/.direnv" = true;
            "**/result" = true;
          };
          "search.exclude" = {
            "**/.direnv" = true;
            "**/result" = true;
          };
        };
        extensions = with pkgs; [
          vscode-marketplace.jnoortheen.nix-ide
          vscode-marketplace.anthropic.claude-code
          vscode-marketplace.yzhang.markdown-all-in-one
          vscode-marketplace.gruntfuggly.todo-tree
        ];
      };
    };
  };
}

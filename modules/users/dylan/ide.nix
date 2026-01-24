_: {
  flake.aspects.dylan._.ide = {
    homeManager = {pkgs, ...}: let
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

        "files.useExperimentalFileWater" = true;
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
        "git.autoRepositoryDetection" = "openEditors";
        "git.repositoryScanMaxDepth" = 1;
        "git.path" = "${pkgs.git}/bin/git";
        "git.autorefresh" = false;
        "git.detectSubmodules" = false;
        "git.detectSubmodulesLimit" = 1;
        "terminal.integrated.inheritEnv" = false;
      };
    in {
      home.file.".config/Code/User/settings.json".text = builtins.toJSON userSettings;
      home.file.".vscode-server/data/Machine/settings.json".text = builtins.toJSON userSettings;
    };
  };
}

{pkgs, ...}: {
  flake.aspects.git = let
    git = {
      environment.systemPackages = [
        pkgs.git
      ];
    };
  in {
    nixos = git;
    darwin = git;
    homeManager = {
      home.packages = with pkgs; [
        difftastic
        gh
      ];

      programs.git = {
        # Username and email need to be set in user aspect
        enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          pager.difftool = "difftastic";
          difftool.prompt = false;
          difftool.difftastic.cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE";
          core.editor = "nvim";
        };
        ignores = [
          ".DS_Store"
          ".direnv"
          ".envrc"
          ".github"
          ".vscode"
          ".claude"
          ".copilot"
          "CLAUDE.md"
          "COPILOT*.md"
          "*.code-workspace"
          "result-*"
          "result"
        ];
        lfs.enable = true;
        delta.enable = true;
        delta.options = {
          line-numbers = true;
          side-by-side = false;
        };
      };
    };
  };
}

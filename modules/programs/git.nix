{...}: {
  flake.aspects.git = let
    makeConfig = pkgs: {
      environment.systemPackages = [
        pkgs.git
      ];
      # Allow root to operate on user-owned repos (needed for doas/sudo nixos-rebuild)
      programs.git.config.safe.directory = "/home/dylan/flake";
    };
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        difftastic
        gh
      ];

      programs.git = {
        # Username and email need to be set in user aspect
        enable = true;
        settings = {
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
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          line-numbers = true;
          side-by-side = false;
        };
      };
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}

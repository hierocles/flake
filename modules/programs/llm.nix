{inputs, ...}: {
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  flake.aspects.llm = let
    # Shared configuration factory function
    makeConfig = pkgs: let
      llm-agents-pkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      llm-packages = with llm-agents-pkgs; [
        claude-code
        opencode
        copilot-cli
        cursor-agent
        gemini-cli
        ccstatusline
        ccusage
        copilot-language-server
      ];
    in {
      environment.systemPackages = llm-packages;
    };
  in {
    nixpkgs.overlays = [
      (final: prev: let
        llm-agents-pkgs = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system};
      in {
        claude-code = llm-agents-pkgs.claude-code;
        opencode = llm-agents-pkgs.opencode;
        copilot-cli = llm-agents-pkgs.copilot-cli;
        gemini-cli = llm-agents-pkgs.gemini-cli;
        copilot-language-server = llm-agents-pkgs.copilot-language-server;
      })
    ];
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}

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
        #gemini-cli # Not building right now, Numtide needs to update
        ccstatusline
        #ccusage # Causing build error
        copilot-language-server
      ];
    in {
      environment.systemPackages = llm-packages;
    };
  in {
    nixpkgs.overlays = [
      (_final: prev: let
        llm-agents-pkgs = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system};
      in {
        inherit (llm-agents-pkgs) claude-code;
        inherit (llm-agents-pkgs) opencode;
        inherit (llm-agents-pkgs) copilot-cli;
        #gemini-cli = llm-agents-pkgs.gemini-cli;
        inherit (llm-agents-pkgs) copilot-language-server;
      })
    ];
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}

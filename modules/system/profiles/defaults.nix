{inputs, ...}: {
  flake.aspects.system-defaults = let
    stableOverlay = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) config system;
      };
    };

    commonSubstituters = [
      # high priority since it's almost always used
      "https://cache.nixos.org?priority=10"
      "https://install.determinate.systems"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];

    commonTrustedPublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];

    commonExperimentalFeatures = [
      "nix-command"
      "flakes"
    ];
  in {
    nixos = {
      nixpkgs.overlays = [stableOverlay];
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.11";
      nix.settings = {
        substituters =
          commonSubstituters
          ++ [
            "https://watersucks.cachix.org"
          ];
        trusted-public-keys =
          commonTrustedPublicKeys
          ++ [
            "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
          ];
        experimental-features = commonExperimentalFeatures;
        download-buffer-size = 1024 * 1024 * 1024;
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';
      users.mutableUsers = false;
    };

    darwin = {pkgs, ...}: {
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = 6;
      nixpkgs.overlays = [stableOverlay];
      determinate-nix.customSettings = {
        eval-cores = 0;
        flake-registry = "";
        lazy-trees = true;
        warn-dirty = false;
        experimental-features = commonExperimentalFeatures;
        extra-experimental-features = [
          "build-time-fetch-tree"
          "parallel-eval"
        ];
        substituters = commonSubstituters;
        trusted-public-keys = commonTrustedPublicKeys;
      };
      environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];
      home-manager.sharedModules = [
        {
          home.activation = {
            copyNixApps = inputs.home-manager.lib.hm.dag.entryAfter ["linkGeneration"] ''
              # Create directory for the applications
              mkdir -p "$HOME/Applications/Nix Apps"
              # Remove old entries
              rm -rf "$HOME/Applications/Nix Apps"/*
              # Get the target of the symlink from home-manager
              NIXAPPS="$newGenPath/home-path/Applications"
              # For each application
              for app_link in "$NIXAPPS"/*; do
                if [ -d "$app_link" ] || [ -L "$app_link" ]; then
                    # Resolve the symlink to get the actual app in the nix store
                    app_source=$(readlink -f "$app_link")
                    appname=$(basename "$app_source")
                    target="$HOME/Applications/Nix Apps/$appname"

                    # Create the basic structure
                    mkdir -p "$target"
                    mkdir -p "$target/Contents"

                    # Copy the Info.plist file
                    if [ -f "$app_source/Contents/Info.plist" ]; then
                      mkdir -p "$target/Contents"
                      cp -f "$app_source/Contents/Info.plist" "$target/Contents/"
                    fi

                    # Copy icon files
                    if [ -d "$app_source/Contents/Resources" ]; then
                      mkdir -p "$target/Contents/Resources"
                      find "$app_source/Contents/Resources" -name "*.icns" -exec cp -f {} "$target/Contents/Resources/" \;
                    fi

                    # Symlink the MacOS directory (contains the actual binary)
                    if [ -d "$app_source/Contents/MacOS" ]; then
                      ln -sfn "$app_source/Contents/MacOS" "$target/Contents/MacOS"
                    fi

                    # Symlink other directories
                    for dir in "$app_source/Contents"/*; do
                      dirname=$(basename "$dir")
                      if [ "$dirname" != "Info.plist" ] && [ "$dirname" != "Resources" ] && [ "$dirname" != "MacOS" ]; then
                        ln -sfn "$dir" "$target/Contents/$dirname"
                      fi
                    done
                  fi
                  done
            '';
          };
        }
      ];
    };

    homeManager = {
      config,
      pkgs,
      ...
    }: {
      home.homeDirectory =
        if pkgs.stdenv.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}";
      home.stateVersion = "25.11";
    };
  };
}

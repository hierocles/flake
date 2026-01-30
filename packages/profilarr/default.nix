{
  lib,
  stdenv,
  fetchFromGitHub,
  deno,
  git,
  cacert,
  makeWrapper,
}:
let
  pname = "profilarr";
  version = "2.0.0-unstable";

  src = fetchFromGitHub {
    owner = "Dictionarry-Hub";
    repo = "Profilarr";
    rev = "v2";
    hash = "sha256-N/9XlUPWOewUlsHp19BbsW74mabM2VtBlFeYv8V1cdk=";
  };

  # Build the binary in a FOD (allowed network access)
  profilarrBinary = stdenv.mkDerivation {
    pname = "${pname}-binary";
    inherit version src;

    nativeBuildInputs = [deno cacert];

    # Disable fixup to avoid issues with FOD
    dontFixup = true;

    buildPhase = ''
      export HOME="$TMPDIR"
      export DENO_DIR="$TMPDIR/deno-cache"
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

      # Install all dependencies
      deno install --node-modules-dir

      # Build the frontend with Vite
      deno run -A npm:vite build

      # Compile to standalone binary
      deno compile \
        --no-check \
        --allow-net \
        --allow-read \
        --allow-write \
        --allow-env \
        --allow-ffi \
        --allow-run \
        --allow-sys \
        --output $out/profilarr \
        dist/build/mod.ts
    '';

    installPhase = ''
      # Binary already placed in $out during build
      chmod +x $out/profilarr
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-+dS0suZOXyaEPtMv10Lbb+blf0mTeSDIoJL1+8h43f0=";
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    # No src needed, we use the pre-built binary
    dontUnpack = true;

    nativeBuildInputs = [makeWrapper];

    # Don't strip the binary - Deno stores metadata at the end
    dontStrip = true;

    installPhase = ''
      mkdir -p $out/bin
      cp ${profilarrBinary}/profilarr $out/bin/

      # Wrap with runtime dependencies in PATH
      # Note: APP_BASE_PATH should be set to a writable directory at runtime
      # e.g., --set APP_BASE_PATH "/var/lib/profilarr"
      wrapProgram $out/bin/profilarr \
        --prefix PATH : ${lib.makeBinPath [git]}
    '';

    meta = {
      description = "Configuration Management Platform for Radarr/Sonarr";
      homepage = "https://github.com/Dictionarry-Hub/Profilarr";
      license = lib.licenses.agpl3Only;
      maintainers = [];
      mainProgram = "profilarr";
      platforms = lib.platforms.linux;
    };
  }

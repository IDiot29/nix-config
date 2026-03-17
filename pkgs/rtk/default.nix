{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "0.30.0";
  sources = {
    x86_64-linux = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-unknown-linux-musl.tar.gz";
      sha256 = "4bc9f340842b1948bd7e9348e2a1a9cced1b39d2cbb2687376ef9b436aa2fcee";
    };
    aarch64-darwin = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-aarch64-apple-darwin.tar.gz";
      sha256 = "0c7a47c6d65f4bf2222170f825e2c9fb9f59109ac9ce16a89c9bcdc0f6606499";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
    or (throw "rtk is not packaged for ${stdenvNoCC.hostPlatform.system} in this repository");
in
stdenvNoCC.mkDerivation {
  pname = "rtk";
  inherit version;

  src = fetchurl {
    inherit (source) url sha256;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    tar -xzf "$src" -C "$out/bin"
    chmod +x "$out/bin/rtk"
    runHook postInstall
  '';

  meta = {
    description = "CLI proxy that reduces LLM token consumption on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    license = lib.licenses.mit;
    mainProgram = "rtk";
    platforms = builtins.attrNames sources;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}

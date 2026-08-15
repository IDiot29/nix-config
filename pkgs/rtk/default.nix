{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "0.45.0";
  sources = {
    x86_64-linux = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-xMA2+/GB/FXvMpeGyMF+DUJ5crBTuCWUTZaKaq/vG6Q=";
    };
    aarch64-darwin = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-aarch64-apple-darwin.tar.gz";
      hash = "sha256-BkFRz8LVCyTYELBqCvLkG5yUXoNTTkxDjD0+rmB/w/Q=";
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
    inherit (source) url hash;
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
    license = lib.licenses.asl20;
    mainProgram = "rtk";
    platforms = builtins.attrNames sources;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}

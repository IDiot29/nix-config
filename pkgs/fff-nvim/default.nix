{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  vimUtils,
}:
let
  pname = "fff-nvim";
  version = "0.6.4";

  sources = {
    x86_64-linux = {
      asset = "x86_64-unknown-linux-gnu.so";
      library = "libfff_nvim.so";
      sha256 = "584162e19c4b66587611308837abfedad89cc1baf297207d2a06371910c10739";
    };
    aarch64-darwin = {
      asset = "aarch64-apple-darwin.dylib";
      library = "libfff_nvim.dylib";
      sha256 = "765228cc2b5876108a5cbc882f860a6c1200e692bfbb8a38f1aab0c7c9ad0d03";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "fff.nvim is not packaged for ${stdenvNoCC.hostPlatform.system} in this repository");

  nativeLibrary = fetchurl {
    url = "https://github.com/dmtrKovalenko/fff.nvim/releases/download/v${version}/${source.asset}";
    inherit (source) sha256;
  };
in
vimUtils.buildVimPlugin {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "v${version}";
    sha256 = "11zbmi07n0dydg4isznza2qcvnhz5ra68b1g6b3za06mxfl75vmy";
  };

  postInstall = ''
    install -Dm755 ${nativeLibrary} "$out/target/release/${source.library}"
  '';

  nvimSkipModules = [
    "empty_config"
  ];

  meta = {
    description = "Fast fuzzy file finder for Neovim with prebuilt native library";
    homepage = "https://github.com/dmtrKovalenko/fff.nvim";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}

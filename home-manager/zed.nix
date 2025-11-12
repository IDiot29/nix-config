{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  ...
}:
stdenv.mkDerivation rec {
  pname = "zed-editor";
  version = "0.211.6";

  src = fetchurl {
    url = "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz";
    sha256 = "sha256-gNDp8Zq0xJzPJdN+/s/AKKjU9lyU6RXYFzp3zlEtLxs=";
  };

  nativeBuildInputs = [autoPatchelfHook makeWrapper];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libxcb
    libxkbcommon
    wayland
    vulkan-loader
    alsa-lib
    libGL
    fontconfig
    freetype
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec $out/share

    # Copy everything
    cp -r lib $out/ 2>/dev/null || true
    cp -r libexec $out/ 2>/dev/null || true
    cp -r share $out/ 2>/dev/null || true

    # Copy the CLI binary
    cp bin/zed $out/bin/
    chmod +x $out/bin/zed

    # Wrap the binary with library paths
    wrapProgram $out/bin/zed \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --set WAYLAND_DISPLAY "wayland-1"
  '';

  meta = with lib; {
    description = "High-performance, multiplayer code editor";
    homepage = "https://zed.dev";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}

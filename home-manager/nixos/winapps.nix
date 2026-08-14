{
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
  ];

  xdg.configFile."winapps/compose.yaml" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    source = inputs.winapps + "/compose.yaml";
  };
}

{lib, pkgs, ...}: {
  # Niri config file - compositor is enabled at NixOS system level
  # The niri.homeModules.config is auto-imported when using HM as NixOS module
  xdg.configFile."niri/config.kdl" = lib.mkIf pkgs.stdenv.isLinux {
    source = ./niri-config.kdl;
  };
}

{lib, pkgs, ...}: {
  # Niri config file - compositor is enabled at NixOS system level
  # The niri.homeModules.config is auto-imported when using HM as NixOS module
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
    brightnessctl
    cliphist
    wireplumber
    wl-clipboard
    xwayland-satellite
  ]);

  xdg.configFile."niri/config.kdl" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    source = ./niri-config.kdl;
  };
}

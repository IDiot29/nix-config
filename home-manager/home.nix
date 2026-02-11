{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Flake inputs
    # Note: niri home module is provided via NixOS module integration
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.beta
    inputs.nvf.homeManagerModules.default
    inputs.vicinae.homeManagerModules.default
    # Shared Home Manager module sets
    ../modules/home-manager/common/default.nix
    ../modules/home-manager/nixos/default.nix
  ];

  home = {
    username = "rivaldo";
    homeDirectory = if pkgs.stdenv.isLinux then "/home/rivaldo" else "/Users/rivaldo";
  };

  programs.zen-browser = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

  home.stateVersion = "25.05";
}

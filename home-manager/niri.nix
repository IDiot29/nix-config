# Niri window manager configuration
{ config, pkgs, ... }:

{
  # Configure niri with your custom config
  # This prevents it from being regenerated on every rebuild
  programs.niri.config = builtins.readFile ./niri/niri-config.kdl;
}

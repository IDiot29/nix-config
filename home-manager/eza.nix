# Eza 
{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };
}

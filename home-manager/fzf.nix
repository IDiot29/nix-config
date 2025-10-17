# FZF
{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };
}

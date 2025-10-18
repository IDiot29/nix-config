# Atuin - Shell history manager
{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    # Disable auto fish integration to avoid bind -k error
    enableFishIntegration = false;
  };
}

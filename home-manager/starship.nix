# Starship
{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    # TODO: Customize starship
    # See: https://starship.rs/config/
  };
}

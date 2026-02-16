{
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrains Mono";
    };
    shellIntegration.enableFishIntegration = true;
  };
}

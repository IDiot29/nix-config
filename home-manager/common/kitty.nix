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
      package = pkgs.jetbrains-mono;
    };
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = lib.getExe pkgs.fish;
    };
  };
}

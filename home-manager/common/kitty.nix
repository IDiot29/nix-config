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
    extraConfig = ''
      # Can't do shift+enter on opencode on tmux, https://github.com/anomalyco/opencode/issues/167#issuecomment-3708163433
      map shift+enter send_text all \x1b[13;2u
      map ctrl+enter send_text all \x1b[13;5u
    '';
  };
}

{
  lib,
  pkgs,
  ...
}: {
  xdg.configFile."ghostty/config".text = ''
    command = "${lib.getExe pkgs.fish}"
    theme = "Catppuccin Mocha"
  '';
}

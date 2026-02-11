{
  lib,
  pkgs,
  ...
}: let
  nvfSettings = import ../../nixos/nvf/settings.nix {inherit pkgs lib;};
in {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;
    settings = nvfSettings;
  };
}

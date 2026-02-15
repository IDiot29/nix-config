{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;
    settings = import ./settings.nix {inherit inputs pkgs lib;};
  };
}

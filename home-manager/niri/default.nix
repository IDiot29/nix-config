{
  config,
  pkgs,
  ...
}: {
  programs.niri.config = builtins.readFile ./niri-config.kdl;
}

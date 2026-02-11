{
  pkgs,
  ...
}: {
  imports = [
    ./common/default.nix
  ];

  home = {
    username = "rivaldo";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}

{lib, ...}: {
  imports = [
    ./nvf/default.nix
  ];

  home.homeDirectory = lib.mkForce "/Users/rivaldo";
}

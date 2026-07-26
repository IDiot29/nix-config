{lib, ...}: {
  imports = [
    ./omniwm
  ];

  home.homeDirectory = lib.mkForce "/Users/rivaldo";
}

{lib, pkgs, ...}: {
  imports = [
    ./dank-material-shell.nix
    ./niri/default.nix
    ./noctalia-shell.nix
    ./vicinae.nix
    ./winapps.nix
  ];

  home.homeDirectory = lib.mkDefault "/home/rivaldo";
  home.packages = [pkgs.podman-compose];
  programs.zen-browser.enable = true;
  systemd.user.startServices = "sd-switch";
}

{lib, ...}: {
  imports = [
    ./dank-material-shell.nix
    ./flatpak.nix
    ./niri/default.nix
    ./noctalia-shell.nix
    ./nvf/default.nix
    ./vicinae.nix
    ./winapps.nix
  ];

  home.homeDirectory = lib.mkDefault "/home/rivaldo";
  programs.zen-browser.enable = true;
  systemd.user.startServices = "sd-switch";
}

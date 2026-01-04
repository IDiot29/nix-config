{lib, pkgs, ...}: {
  programs.ghostty = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = {
      command = "/etc/profiles/per-user/rivaldo/bin/fish";
      theme = "Catppuccin Mocha";
    };
  };
}

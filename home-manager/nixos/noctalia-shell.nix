{
  lib,
  pkgs,
  ...
}: {
  programs.noctalia-shell = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    # dms remains the default shell; but noctalia can be use with systemd
    systemd.enable = true;

    settings = {
      colorSchemes.predefinedScheme = "Catppuccin";
    };
  };

  xdg.configFile."noctalia/settings.json".force = true;

  # The unit remains startable via `systemctl --user start noctalia-shell.service`.
  systemd.user.services.noctalia-shell = lib.mkIf pkgs.stdenv.isLinux {
    Install.WantedBy = lib.mkForce [ ];
  };
}

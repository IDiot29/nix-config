{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Noctalia provides its own Home Manager module. We only import it on Linux
  # because this repo shares home-manager/home.nix with nix-darwin.
  imports = lib.optionals pkgs.stdenv.isLinux [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    # Create a systemd user service, but do not autostart it.
    # DMS remains the default shell; Noctalia is started manually when needed.
    systemd.enable = true;
  };

  # Prevent Home Manager from enabling the service automatically (WantedBy).
  # The unit remains startable via `systemctl --user start noctalia-shell.service`.
  systemd.user.services.noctalia-shell = lib.mkIf pkgs.stdenv.isLinux {
    Install.WantedBy = lib.mkForce [ ];
  };
}

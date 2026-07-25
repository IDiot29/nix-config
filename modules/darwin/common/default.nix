{
  inputs,
  pkgs,
  ...
}: let
  caches = import ../../../caches.nix;
in {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (_final: _super: {
        direnv = _super.direnv.overrideAttrs (_: {
          # TODO: Remove when https://github.com/NixOS/nixpkgs/issues/507531 is fixed.
          doCheck = false;
        });
      })
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;

  # Determinate Nix owns nix.conf because nix.enable is false.
  environment.etc."nix/nix.custom.conf".text = ''
    trusted-users = root rivaldo
    accept-flake-config = true
    extra-substituters = ${builtins.concatStringsSep " " caches.substituters}
    extra-trusted-public-keys = ${builtins.concatStringsSep " " caches.trustedPublicKeys}
  '';

  environment.systemPackages = [pkgs.devenv];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fish.enable = true;
  services.netbird.enable = true;

  system = {
    primaryUser = "rivaldo";
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
      };

      screencapture = {
        location = "~/Pictures/screenshots";
      };

      screensaver = {
        askForPasswordDelay = 10;
      };
    };
  };
}

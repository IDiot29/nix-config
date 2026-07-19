{
  inputs,
  pkgs,
  ...
}: {
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

  nix = {
    enable = false;
    settings = {
      store = "daemon";
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "rivaldo"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://vicinae.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };

  environment.etc."nix/nix.custom.conf".text = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  environment.systemPackages = with pkgs; [
    devenv
    home-manager
  ];

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

{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    enable = false;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "rivaldo"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nixtip.pelindungbumi.dev"
        "https://vicinae.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixtip.pelindungbumi.dev-1:2w1Zf43fmGc63a7dkAYA0PmweRCUGEYHtp+gqdRQPkY="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    devenv
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

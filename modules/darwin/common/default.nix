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
    };
  };

  programs.fish.enable = true;

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

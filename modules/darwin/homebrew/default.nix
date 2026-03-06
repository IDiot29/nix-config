{
  inputs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    user = "rivaldo";
    enableRosetta = true;
    autoMigrate = false;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    brews = [];

    casks = [
      "ghostty"
      "google-chrome"
      "iterm2"
      "keepassxc"
      "obs"
      "pritunl"
      "raycast"
      "telegram"
      "vlc"
    ];

    taps = [
      "homebrew/core"
      "homebrew/cask"
    ];
  };
}

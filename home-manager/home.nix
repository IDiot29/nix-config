# My Home-manager config
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import other home-manager modules
  imports = [
    # Niri
    inputs.niri.homeModules.niri

    # DankMaterialShell (without niri module to prevent config regeneration)
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default

    # Zen Browser (using beta module)
    inputs.zen-browser.homeModules.beta

    # NVF Home-Manager module
    inputs.nvf.homeManagerModules.default

    # Custom configurations
    ./niri.nix
    ./fish.nix
    ./git.nix
    ./packages.nix
    ./starship.nix
    ./bat.nix
    ./eza.nix
    ./fzf.nix
    ./zoxide.nix
    ./atuin.nix
    ./nvf/default.nix
  ];

  # User info
  home = {
    username = "rivaldo";
    homeDirectory = "/home/rivaldo";
  };

  # Programs
  programs.home-manager.enable = true;

  # Zen Browser
  programs.zen-browser.enable = true;

  # DankMaterialShell configuration
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableBrightnessControl = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}

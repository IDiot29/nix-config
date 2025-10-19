{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "thinker";
  networking.networkmanager = {
    enable = true;
    logLevel = "INFO";
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Custom hosts entries
  networking.hosts = {
    "127.0.0.345" = ["example.com"];
  };

  # Set your time zone
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # GNOME Desktop
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = false;

  # Greetd display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Define a user account
  users.users.rivaldo = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJetj70q+Atvrws3WlGgJJrqq4Dvnok5OLHccgwy0Xx rivaldo.silalahi@lintasarta.co.id"
    ];
  };

  # Enable programs
  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.nm-applet.enable = true;

  # Enable services
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Enable virtualisation
  virtualisation.docker = {
    enable = true;
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
    ghostty
    git
    curl
    tailscale
    openvpn
  ];

  # Enable Service
  services.tailscale.enable = true;

  #Systemd
  #For Pritunl
  systemd.packages = [pkgs.pritunl-client];
  systemd.targets.multi-user.wants = ["pritunl-client.service"];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}

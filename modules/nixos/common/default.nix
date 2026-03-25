{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nixtip.pelindungbumi.dev"
        "https://niri.cachix.org"
        "https://vicinae.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixtip.pelindungbumi.dev-1:2w1Zf43fmGc63a7dkAYA0PmweRCUGEYHtp+gqdRQPkY="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager = {
    enable = true;
    logLevel = "INFO";
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  networking.hosts = {
    "127.0.0.1" = ["example.com"];
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

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

  programs.firefox.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.niri.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.steam-hardware.enable = true;
  programs.nm-applet.enable = true;
  programs.nix-ld.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
  services.flatpak.enable = true;
  services.netbird.enable = true;
  services.tailscale.enable = true;

  systemd.packages = [pkgs.pritunl-client];
  systemd.targets.multi-user.wants = ["pritunl-client.service"];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    alacritty
    tailscale
    openvpn
    pritunl-client
    devenv
    home-manager
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  system.stateVersion = "25.05";
}

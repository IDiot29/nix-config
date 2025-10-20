# My packages
{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    neovim
    git
    nil
    nixpkgs-fmt
    nodejs
    ripgrep
    bat
    btop
    fastfetch
    eza
    fd
    fzf
    zoxide
    atuin
    kubectl
    kustomize
    fluxcd
    dig
    helm
    sops

    # GUI
    alacritty
    fuzzel
    obs-studio
    mpv
    pritunl-client
    keepassxc

    # Wayland
    swaylock
    xwayland-satellite

    # Zed - Using prebuild from github release
    (pkgs.callPackage ./zed.nix {})
  ];
}

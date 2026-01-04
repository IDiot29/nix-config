{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    neovim
    bat
    btop
    pwgen
    zoxide
    starship
    nodejs
    atuin
    gh
    kubectl
    fluxcd
    cilium-cli
    kustomize
    podman
    podman-compose
    fzf

    # GUI
    keepassxc
  ];
}

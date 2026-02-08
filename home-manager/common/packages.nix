{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    neovim
    nushell
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
    kubernetes-helm
    jq
    devenv
    bun
    python3
    jujutsu
    yq

    # GUI
    keepassxc
    obs-studio
  ];
}

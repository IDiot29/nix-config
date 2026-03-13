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
    sops
    pandoc
    ripgrep
    antigravity
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ghostty
    keepassxc
    obs-studio
  ];
}

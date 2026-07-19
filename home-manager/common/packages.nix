{
  config,
  pkgs,
  lib,
  ...
}: let
  rtk = pkgs.callPackage ../../pkgs/rtk {};
in {
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
    google-cloud-sdk
    fluxcd
    cilium-cli
    kustomize
    podman
    podman-compose
    fzf
    kubernetes-helm
    jq
    bun
    python3
    jujutsu
    yq
    sops
    pandoc
    ripgrep
    antigravity
    rtk
    nixd
    fd
    herdr
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ghostty
    keepassxc
    obs-studio
  ];
}

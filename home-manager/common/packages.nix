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
    rtk
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ghostty
    keepassxc
    obs-studio
  ];
}

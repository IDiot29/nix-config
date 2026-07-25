{
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
    btop
    pwgen
    nodejs
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
    antigravity-ide
    rtk
    nixd
    fd
    hunk
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ghostty
    keepassxc
    obs-studio
  ];
}

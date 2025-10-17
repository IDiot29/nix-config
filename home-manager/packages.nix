# My packages
{ config, pkgs, ... }:

{
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
    flux
    dig
    helm
    
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
  ];
}

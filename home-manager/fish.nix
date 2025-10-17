# Fish shell configuration
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      set -gx TERM "xterm-256color"

      # Disable greeting
      set fish_greeting
      
      # Load secrets if file exists (not tracked in git)
      if test -f ~/.config/fish/secrets.fish
        source ~/.config/fish/secrets.fish
      end
    '';
    
    shellAliases = {
      # System management
      rebuild = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#thinker";
      rebuild-test = "cd ~/.config/nixos && sudo nixos-rebuild test --flake .#thinker";
      update-flake = "cd ~/.config/nixos && nix flake update";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      
      # Better ls
      ls = "eza -l --icons";
      la = "ez -l --all";
      
      # Shortcuts
      nv = "neovim";
      vim = "neovim";
      ff = "fastfetch";
      
      # Zoxide
      cd = "z";
      
      # NixOS specific
      bjg = "echo I use NixOS, BTW";
      
    };
    
    # Fish plugins (optional)
    plugins = [
      # {
      #   name = "tide";
      #   src = pkgs.fishPlugins.tide.src;
      # }
    ];
  };
}

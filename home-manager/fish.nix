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

      # Function to source bash-style .env files
      function envsource
        if test (count $argv) -eq 0; or test "$argv[1]" = "--help"
          echo "Usage: envsource <file>"
          echo ""
          echo "Source bash-style environment files in fish shell"
          echo ""
          echo "Example:"
          echo "  envsource .env"
          echo "  envsource /path/to/my-vars.env"
          echo ""
          echo "Supports formats:"
          echo "  KEY=value"
          echo "  export KEY=value"
          echo '  KEY="value"'
          echo "  KEY='value'"
          return 0
        end

        set -l envfile $argv[1]
        if not test -f $envfile
          echo "Error: File '$envfile' not found"
          return 1
        end

        for line in (cat $envfile | grep -v '^#' | grep -v '^$')
          set item (string split -m 1 '=' -- $line)
          set -l value (string trim --chars='\'"' -- $item[2])
          set -gx $item[1] $value
        end
        echo "Sourced $envfile"
      end

      # Enable Atuin
      atuin init fish | sed "s/-k up/up/g" | source
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

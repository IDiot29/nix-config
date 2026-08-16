{
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx TERM "xterm-256color"

      ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        set -gx PATH ~/.npm-global/bin $PATH
        set -gx NPM_CONFIG_PREFIX ~/.npm-global
      ''}

      set fish_greeting

      set -l fish_secrets_path ~/.config/fish/secrets.fish
      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        set fish_secrets_path /run/secrets/rendered/fish-secrets
      ''}

      if test -f $fish_secrets_path
        source $fish_secrets_path
      end

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

        for line in (cat $envfile | string match -r -v '^[[:space:]]*(#|$)')
          set line (string trim -- $line)
          set line (string replace -r '^export[ \t]+' "" -- $line)
          set item (string split -m 1 '=' -- $line)
          if test (count $item) -ne 2
            echo "Skipping malformed line in '$envfile'" >&2
            continue
          end

          set -l key $item[1]
          if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $key
            echo "Skipping invalid variable name '$key' in '$envfile'" >&2
            continue
          end

          set -l value (string trim --chars='\'"' -- $item[2])
          set -gx $key $value
        end
        echo "Sourced $envfile"
      end

      atuin init fish | sed "s/-k up/up/g" | source

      starship init fish | source

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        set -gx PATH ~/.npm-global/bin $PATH
        set -gx NPM_CONFIG_PREFIX ~/.npm-global

        eval (/opt/homebrew/bin/brew shellenv fish)
      ''}

      zoxide init fish | source
    '';

    shellAliases = {
      rebuild = "${if pkgs.stdenv.hostPlatform.isLinux then "cd ~/.config/nix && sudo nixos-rebuild switch --flake .#thinker" else "cd ~/.config/nix && sudo darwin-rebuild switch --flake .#Rivaldos-MacBook-Pro"}";
      update-flake = "cd ~/.config/nix && nix flake update";
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      ll = "ls -la";
      vim = "nvim";
      nv = "nvim";
      cd = "z";
      ff = "fastfetch";
      k = "kubectl";
    } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      bjg = "echo I use NixOS, BTW";
    };
  };
}

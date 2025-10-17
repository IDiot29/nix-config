# Git configuration
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    userName = "vldo766hi"; 
    userEmail = "rivaldo.silalahi@lintasarta.co.id";
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --oneline --graph --decorate --all";
      amend = "commit --amend --no-edit";
    };
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim"; 
      
      diff.algorithm = "histogram";
      
      push.autoSetupRemote = true;
      
      # Credential helper
      # credential.helper = "store";
    };
  };
}

# Neovim configuration via NVF
{ pkgs, lib, ... }:

let
  nvfSettings = import ./settings.nix { inherit pkgs lib; };
in {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;
    settings = nvfSettings;
  };

  # Lazygit Catppuccin Mocha theme
  xdg.configFile."lazygit/config.yml" = {
    force = true;
    text = ''
      gui:
        theme:
          activeBorderColor:
            - '#89b4fa' # Blue
            - bold
          inactiveBorderColor:
            - '#a6adc8' # Subtext0
          searchingActiveBorderColor:
            - '#f9e2af' # Yellow
            - bold
          optionsTextColor:
            - '#89b4fa' # Blue
          selectedLineBgColor:
            - '#313244' # Surface0
          selectedRangeBgColor:
            - '#313244' # Surface0
          cherryPickedCommitBgColor:
            - '#45475a' # Surface1
          cherryPickedCommitFgColor:
            - '#89b4fa' # Blue
          unstagedChangesColor:
            - '#f38ba8' # Red
          defaultFgColor:
            - '#cdd6f4' # Text
      git:
        pagers:
          - colorArg: always
            pager: delta --dark --paging=never
    '';
  };
}

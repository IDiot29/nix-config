# WinApps Home Manager module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.winapps;
  hasInlineConfig = cfg.configText != null;
  hasExternalConfig = cfg.configFile != null;
  hasInlineCompose = cfg.composeText != null;
  hasExternalCompose = cfg.composeFile != null;
in {
  options.programs.winapps = {
    enable = lib.mkEnableOption "WinApps integration";

    manageConfigFile = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable if you maintain ~/.config/winapps/winapps.conf yourself outside Home Manager.";
    };

    manageComposeFile = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable if you maintain ~/.config/winapps/compose.yaml yourself outside Home Manager.";
    };

    configText = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = ''
        Raw contents for `~/.config/winapps/winapps.conf`. Use this when you are
        comfortable storing the values directly in the flake (for example when
        using placeholder values or when the repository is private).
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to an existing `winapps.conf` on disk. This is useful when you want
        to keep credentials outside of the repo (e.g., in a local `secrets/`
        directory that is git-ignored). When provided, the file is symlinked into
        `~/.config/winapps/winapps.conf`.
      '';
    };

    composeText = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = ''
        Raw contents for `~/.config/winapps/compose.yaml`. Provide this if you
        want Home Manager to install the Docker/Podman compose definition from
        within the flake.
      '';
    };

    composeFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a compose file on disk that should be linked to
        `~/.config/winapps/compose.yaml`. Useful for local, git-ignored copies
        with secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = (!cfg.manageConfigFile) || (hasInlineConfig || hasExternalConfig);
          message = "Set programs.winapps.configText or configFile, or disable manageConfigFile.";
        }
        {
          assertion = !(hasInlineConfig && hasExternalConfig);
          message = "Choose either programs.winapps.configText or configFile, not both.";
        }
        {
          assertion = (!cfg.manageComposeFile) || (hasInlineCompose || hasExternalCompose);
          message = "Set programs.winapps.composeText or composeFile, or disable manageComposeFile.";
        }
        {
          assertion = !(hasInlineCompose && hasExternalCompose);
          message = "Choose either programs.winapps.composeText or composeFile, not both.";
        }
      ];
    }

    (lib.mkIf (cfg.manageConfigFile && hasInlineConfig) {
      home.file.".config/winapps/winapps.conf".text = cfg.configText;
    })

    (lib.mkIf (cfg.manageConfigFile && hasExternalConfig) {
      home.file.".config/winapps/winapps.conf".source = cfg.configFile;
    })

    (lib.mkIf (cfg.manageComposeFile && hasInlineCompose) {
      home.file.".config/winapps/compose.yaml".text = cfg.composeText;
    })

    (lib.mkIf (cfg.manageComposeFile && hasExternalCompose) {
      home.file.".config/winapps/compose.yaml".source = cfg.composeFile;
    })
  ]);
}

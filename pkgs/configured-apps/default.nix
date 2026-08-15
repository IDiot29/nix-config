{
  lib,
  pkgs,
}:
let
  withMainProgram = package: mainProgram:
    package.overrideAttrs (old: {
      meta = (old.meta or {}) // {inherit mainProgram;};
    });

  mkConfigDir = {name, files}:
    pkgs.runCommand name {} ''
      mkdir -p "$out"
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (fileName: source: ''
        install -Dm444 "${source}" "$out/${fileName}"
      '') files)}
    '';
in {
  mkNeovim = {package}: withMainProgram package "nvim";

  mkYazi = {
    package,
    yaziToml,
    themeToml,
  }:
    let
      configDir = mkConfigDir {
        name = "yazi-configured";
        files = {
          "theme.toml" = themeToml;
          "yazi.toml" = yaziToml;
        };
      };
    in
      pkgs.symlinkJoin {
        name = "yazi-configured";
        paths = [package];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram "$out/bin/yazi" \
            --set YAZI_CONFIG_HOME "${configDir}"
        '';
        meta = (package.meta or {}) // {mainProgram = "yazi";};
      };

  mkLazygit = {
    package,
    configFile,
  }:
    pkgs.symlinkJoin {
      name = "lazygit-configured";
      paths = [package];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/lazygit" \
          --add-flags "--use-config-file=${configFile}"
      '';
      meta = (package.meta or {}) // {mainProgram = "lazygit";};
    };

  mkPi = {package}: withMainProgram package "pi";
}

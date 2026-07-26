{
  lib,
  pkgs,
  ...
}: {
  home.activation.omniwmSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settings_dir="$HOME/.config/omniwm"
    ${pkgs.coreutils}/bin/mkdir -p "$settings_dir"
    ${pkgs.coreutils}/bin/install -m 600 \
      ${./settings.toml} "$settings_dir/settings.toml"

    /usr/bin/defaults write -g NSConvolutionOverride1 -float 8.0
    /usr/bin/defaults write -g NSConvolutionOverride2 -float 8.0
  '';
}

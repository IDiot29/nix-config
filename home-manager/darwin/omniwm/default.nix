{
  lib,
  pkgs,
  ...
}: {
  home.activation.omniwmSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settings_dir="$HOME/.config/omniwm"
    ${pkgs.coreutils}/bin/mkdir -p "$settings_dir"
    settings_file="$settings_dir/settings.toml"
    settings_tmp="$settings_file.nix-tmp"
    ${pkgs.coreutils}/bin/install -m 600 ${./settings.toml} "$settings_tmp"
    ${pkgs.coreutils}/bin/mv -f "$settings_tmp" "$settings_file"

    /usr/bin/defaults write -g NSConvolutionOverride1 -float 8.0
    /usr/bin/defaults write -g NSConvolutionOverride2 -float 8.0
  '';
}

{ pkgs, ... }:

let
  swayimg-fit = pkgs.writeShellScriptBin "swayimg-fit" ''
    f="$1"
    size=$(${pkgs.imagemagick}/bin/magick identify -format '%w %h' "$f[0]" 2>/dev/null \
      | ${pkgs.gawk}/bin/awk -v mw=1600 -v mh=900 -v pad=0 '{
          w=$1; h=$2; s=1
          if (w > mw) s = mw / w
          if (h * s > mh) s = mh / h
          printf "%d,%d", w * s + pad, h * s + pad
        }')
    exec ${pkgs.swayimg}/bin/swayimg ''${size:+-S "$size"} "$@"
  '';

  images = [ "image/png" "image/jpeg" "image/webp" "image/gif" "image/bmp" ];
  media  = [
    "video/mp4" "video/x-matroska" "video/webm"
    "audio/flac" "audio/mpeg" "audio/ogg"
  ];
in
{
  home.packages = [ swayimg-fit ];

  xdg.desktopEntries.swayimg-fit = {
    name = "Swayimg (fit)";
    exec = "swayimg-fit %F";
    noDisplay = true;
    mimeType = images;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      (builtins.listToAttrs (map (m: { name = m; value = "swayimg-fit.desktop"; }) images))
      // (builtins.listToAttrs (map (m: { name = m; value = "mpv.desktop"; }) media));
  };

  xdg.configFile."swayimg/init.lua".text = ''
    swayimg.text.visible = false
    swayimg.viewer.default_scale = "fit"
  '';
}

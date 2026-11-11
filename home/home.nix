{ config, pkgs, ... }:

{
  imports = [ ./modules ];

  home.username = "astosolo";
  home.homeDirectory = "/home/astosolo";

  programs.git = {
    enable = true;
    settings = {
      user.name  = "AstoSolo";
      user.email = "adstosolus@gmail.com";
      
      };
  };

  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.packages = with pkgs; [
    qbittorrent
    peazip
    p7zip
    zip
    unzip
    unrar
    libunarr
    swayimg
    mpv
    cliamp

    vesktop
    obs-studio
    easyeffects
    steam
    ayugram-desktop
    protontricks
    prismlauncher
    lutris
    mangohud

    fastfetch
    fetch
    openrgb-with-all-plugins

    # Study, hobby stuff
    wordcraft
    photocraft
    obsidian
    orca-slicer
    spotiflac
    nicotine-plus
    teams-for-linux
    yoinks
    yt-dlp
    ffmpeg
    freecad

    #clion
    (symlinkJoin {
      name = "clion";
      paths = [ jetbrains.clion ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/clion \
          --prefix LD_LIBRARY_PATH : ${stdenv.cc.cc.lib}/lib
      '';
    })
    gcc
    cmake
    ninja
    gdb
    python314


    # Quick start apps
    fuzzel
    awww
    waybar
    mako
    veila
    rofi
    grim
    wayfreeze
    slurp
    satty
    impala
    wiremix

    # Rice start packages
    quickshell

    glib
    gsettings-desktop-schemas
    adwaita-icon-theme
    matugen

    wl-clipboard
    cliphist

    # Desktop portal
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk

  ];

  home.pointerCursor =
  let
    themeName = "Bibata-Material-Seafoam"; # Change -Seafoam to other theme from 28 themes here: https://github.com/SakibShahariar/material-bibata-cursor and theme.conf in mango config
  in {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = themeName;
    size = 24;
    package = pkgs.runCommand "material-bibata-cursor" { } ''
      mkdir -p $out/share/icons
      ln -s ${
        pkgs.fetchzip {
          url = "https://github.com/SakibShahariar/material-bibata-cursor/releases/download/v1.2.0/bibata-material-v1.2.0.tar.gz";
          hash = "sha256-6iUHx/Ylz7AzQuofIZvVw8cecv0/h+tCCgfyHQvpecU=";
        }
      }/${themeName} $out/share/icons/${themeName}
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
  };


  home.file.".config/nvim".source = ../config/nvim;

  home.file.".config/matugen/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/matugen/";

  home.file.".config/mango/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/mango/";

  home.file.".config/quickshell/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/quickshell/";

  home.file.".config/fuzzel/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/fuzzel/";

  home.file.".config/waybar/config.jsonc".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/waybar/config.jsonc";

  home.file.".config/gtk-3.0/gtk.css".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/gtk-3.0/gtk.css";

  home.file.".config/gtk-4.0/gtk.css".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/gtk-4.0/gtk.css";

  home.file.".config/waybar/style.css".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/waybar/style.css";

  home.file.".config/fastfetch/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/fastfetch/";

  home.file.".config/kitty/kitty.conf".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/kitty/kitty.conf";

  home.file.".config/mako/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/mako/";

  home.file.".config/xdg-desktop-portal/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/xdg-desktop-portal/";

  home.file.".config/xdg-desktop-portal-wlr/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/xdg-desktop-portal-wlr/";

}

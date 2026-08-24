{ config, pkgs, lib, ... }:

{
  home.username = "astosolo";
  home.homeDirectory = "/home/astosolo";

  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };

  home.file.".config/nvim".source = ./config/nvim;

  home.packages = with pkgs; [
    
    thunar
    unzip
    zip
    rar

    discord
    steam
    prismlauncher
    nicotine-plus

    fastfetch
    fetch
    btop

    # Quick start apps
    fuzzel
    awww
    waybar
    mako
    wleave

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
  };

  home.file.".config/matugen/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/matugen/";

  home.file.".config/mango/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/mango/";

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

  home.file.".config/wlogout/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/wlogout/";

  home.file.".config/kitty/kitty.conf".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/kitty/kitty.conf";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    config.common.default = [ "gtk" ];
  };
}

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

    fastfetch
    fetch
    btop

    # Quick start apps
    fuzzel
    awww
    waybar
    mako
    wleave

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



  home.file.".config/matugen/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/matugen/";

  home.file.".config/mango/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/mango/";

  home.file.".config/fuzzel/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/fuzzel/";

  home.file.".config/waybar/config.jsonc".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/waybar/config.jsonc";

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
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*"; 
  };
}

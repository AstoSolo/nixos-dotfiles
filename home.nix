{ config, pkgs, ... }:

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

  # home.file.".config/mango".source = ./config/mango;
  home.file.".config/nvim".source = ./config/nvim;
  # home.file.".config/waybar".source = ./config/waybar;

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
    wlogout

    adwaita-icon-theme
    matugen

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

  home.file.".config/matugen/config.toml".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/matugen/config.toml";

  home.file.".config/matugen/templates".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/matugen/templates";

  home.file.".config/mango/".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/mango/";

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

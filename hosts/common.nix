{ lib, pkgs, ... }:

{
  imports = [
    ./modules/ly.nix
    ./modules/virtualisation.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  #limine boot
  boot.loader = {
    timeout = 3;
    limine = {
      enable = true;
      maxGenerations = 10;
      style.wallpaperStyle = "centered";
      style.wallpapers = lib.filesystem.listFilesRecursive ../assets/limine;
    };
  };

  time.timeZone = "Asia/Almaty";
  i18n.defaultLocale = "en_US.UTF-8";

  # Pipewire & Bluetooth
  security.rtkit.enable = true;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
	"bluez5.enable-sbc-xq" = true;
	"bluez5.enable-msbc" = true;
	"bluez5.enable-hw-volume" = true;
	"bluez5.roles" = [
	  "hsp_hs"
          "hsp_ag"
          "hfp_hf"
          "hfp_ag"
        ];
     };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.common.default = [ "wlr" "gtk" ];
  };
  systemd.user.services.xdg-desktop-portal-wlr.path = [ pkgs.fuzzel pkgs.slurp ];
  
  users.users.astosolo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.fish.enable = true;
  users.extraUsers.astosolo = {
    shell = pkgs.fish;
  };

  programs.mango.enable = true;
  programs.dconf.enable = true;
  
  services.gvfs.enable = true;

  services.hardware.openrgb.enable = true;

  services.zerotierone = {
  enable = true;
  joinNetworks = [
    "2873fd00f2e59695"
  ];
};

  environment.systemPackages = with pkgs; [ 
    vim
    wget
    git
    kitty
    firefox
    pavucontrol
    blueman
    helvum
    ntfs3g
    disko
    efibootmgr
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono

    (runCommand "tabler-icons-font" {
      src = fetchzip {
        url = "https://registry.npmjs.org/@tabler/icons-webfont/-/icons-webfont-3.49.0.tgz";
        hash = "sha256-LGqMm1HfC3qp3K/h2NbsOg4Dudgy4WMsllkLXvSIJjs=";
      };
    } ''
      install -Dm644 $src/dist/fonts/tabler-icons.ttf \
        $out/share/fonts/truetype/tabler-icons.ttf
    '')
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.11";

}

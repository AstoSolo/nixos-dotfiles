{ inputs, config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  #limine boot
  boot.loader = {
    limine = {
      enable = true;
      maxGenerations = 10;
      style.wallpaperStyle = "centered";
      style.wallpapers = lib.filesystem.listFilesRecursive ../limine-images;
      extraConfig = ''
        timeout: 3
        default_entry: 2
      '';
    };
  };

  # Display manager
  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
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
  


  users.users.astosolo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.fish.enable = true;
  users.extraUsers.astosolo = {
    shell = pkgs.fish;
  };

  programs.mango.enable = true;
  
  environment.systemPackages = with pkgs; [ 
    vim
    wget
    git
    kitty
    firefox
    pavucontrol
    blueman
    helvum
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
];

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";

}

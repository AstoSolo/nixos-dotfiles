# OmenCtl / omen-space for HP Victus
#
# TEMPORARY WORKAROUND: we don't use upstream `nixosModules.default`
# because its driver is installed without `kernelModuleMakeFlags`,
# so no `.ko.cer` is produced and nixpkgs' module aggregator fails
# (NixOS/nixpkgs#575192). Switch back to
#   inputs.omen-space.nixosModules.default + programs.omen-space.enable = true;
# once NixOS/nixpkgs#578004 lands or upstream fixes the driver build.
#
# Settings: the daemon reads its state from /etc/omen-space/*.json on start
# and re-applies it. We generate those files from Nix (see `hardware.omen-space`
# options below). Files are copied (not symlinked), so changes made in the GUI
# still work and persist until the next `nixos-rebuild`, which resets them to
# what is declared here.

# IMPORTANT!!!
# Written with the help of Claude (Anthropic), because i have no knowledge in this theme!!!


{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.hardware.omen-space;
  system = pkgs.stdenv.hostPlatform.system;

  # Userspace package (daemon, CLI, GUI, tray, overlay) from upstream flake
  omen = inputs.omen-space.packages.${system}.default;

  # Kernel driver (patched hp-wmi + hp-omen-extra), built against the
  # kernel actually in use (config.boot.kernelPackages), with nixpkgs'
  # module make flags so modules_install signs it and writes .ko.cer
  omen-driver = config.boot.kernelPackages.callPackage
    ({ stdenv, kernel, kernelModuleMakeFlags }:
      stdenv.mkDerivation {
        pname = "omen-space-driver";
        version = omen.version;
        src = "${omen.src}/driver";

        hardeningDisable = [ "pic" ];
        nativeBuildInputs = kernel.moduleBuildDependencies;

        makeFlags = kernelModuleMakeFlags ++ [
          "KERNELRELEASE=${kernel.modDirVersion}"
          "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        ];

        installPhase = ''
          runHook preInstall
          make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
            M=$(pwd) INSTALL_MOD_PATH=$out \
            ${lib.escapeShellArgs kernelModuleMakeFlags} \
            modules_install
          runHook postInstall
        '';

        # Stripping in fixupPhase would drop the module signature
        dontStrip = true;
      }) { };

  # NOTE: the daemon deserializes each file as a whole struct; if any
  # required field is missing it silently falls back to ALL defaults.
  # So every file below always contains the complete set of fields.

  rgbJson = {
    inherit (cfg.rgb) mode speed brightness direction power;
    # exactly 8 zone colors, hex without '#'
    colors = lib.take 8 (cfg.rgb.colors ++ lib.replicate 8 (lib.last cfg.rgb.colors));
    win_lock = cfg.rgb.winLock;
    zone_count_override = cfg.rgb.zoneCount;
    hw_effects = false;
  };

  undervoltJson = {
    offsets = {
      core = cfg.undervolt.curveOptimizer; # AMD: Curve Optimizer all-core count
      gpu = 0;
      cache = 0;
      uncore = 0;
      analogio = 0;
    };
    tcc_offset = cfg.undervolt.tccOffset;
    # must be false, otherwise the crash-recovery guard resets offsets to 0
    pending_confirmation = false;
  };

  powerJson = {
    power_profile = cfg.power.profile; # overridden by the detected HW profile on start
    app_profiles_enabled = false;
    app_profiles = { };
    undervolt_mv = 0;
    tcc_offset = cfg.undervolt.tccOffset;
    pl_enabled = cfg.power.limits.enable;
    pl1_w = cfg.power.limits.pl1; # AMD: STAPM + slow limit
    pl2_w = cfg.power.limits.pl2; # AMD: fast limit
    gpu_w = 0;
  };

  json = name: value: (pkgs.formats.json { }).generate "omen-space-${name}.json" value;

  etcFiles = {
    "omen-space/rgb.json" = json "rgb" rgbJson;
    "omen-space/undervolt.json" = json "undervolt" undervoltJson;
    "omen-space/power.json" = json "power" powerJson;
  };
in
{
  # --- Options --------------------------------------------------------
  options.hardware.omen-space = with lib; {
    rgb = {
      mode = mkOption {
        type = types.enum [
          "static" "breathing" "wave" "cycle" "rainbow" "pulse"
          "chase" "sparkle" "candle" "aurora" "disco" "gradient"
        ];
        default = "static";
      };
      colors = mkOption {
        type = types.nonEmptyListOf (types.strMatching "[0-9A-Fa-f]{6}");
        default = [ "FF0000" ];
        description = "Zone colors (hex, no '#'). Padded to 8 with the last one.";
      };
      brightness = mkOption { type = types.ints.between 0 100; default = 100; };
      speed = mkOption { type = types.ints.between 0 100; default = 50; };
      direction = mkOption { type = types.enum [ "ltr" "rtl" ]; default = "ltr"; };
      power = mkOption { type = types.bool; default = true; description = "Backlight on/off."; };
      winLock = mkOption { type = types.bool; default = false; };
      zoneCount = mkOption {
        type = types.nullOr (types.enum [ 4 8 ]);
        default = null;
        description = "Zone count override; null = auto.";
      };
    };

    undervolt = {
      curveOptimizer = mkOption {
        type = types.ints.between (-30) 30;
        default = 0;
        description = "AMD Curve Optimizer all-core count. Negative = undervolt.";
      };
      tccOffset = mkOption {
        type = types.ints.between 0 15;
        default = 0;
        description = "Max CPU temp = 100 - tccOffset (AMD: ryzenadj --tctl-temp).";
      };
    };

    power = {
      profile = mkOption {
        type = types.enum [ "power-saver" "balanced" "performance" ];
        default = "balanced";
      };
      limits = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Apply PL1/PL2 on start; false = keep firmware defaults.";
        };
        pl1 = mkOption { type = types.ints.between 25 160; default = 45; };
        pl2 = mkOption { type = types.ints.between 45 200; default = 115; };
      };
    };
  };

  # --- Config ---------------------------------------------------------
  config = {
    environment.systemPackages = [
      omen
      pkgs.ryzenadj
    ];

    # D-Bus, udev, systemd units shipped by the package
    services.dbus.packages = [ omen ];
    services.udev.packages = [ omen ]; # missing in upstream module
    systemd.packages = [ omen ];

    # Declarative settings: copied into /etc so the daemon can still write them
    environment.etc = lib.mapAttrs (_: source: {
      inherit source;
      mode = "0644";
    }) etcFiles;

    systemd.services.omen-space-daemon = {
      wantedBy = [ "multi-user.target" ];

      # The unit is sandboxed and doesn't see systemPackages,
      # so tools the daemon calls must be on its PATH explicitly
      path = with pkgs; [
        power-profiles-daemon # PPD sync with desktop status bars (upstream #283)
        ryzenadj              # CPU power limit tuning / Curve Optimizer
      ];

      # Restart the daemon when declared settings change, so they apply on switch
      restartTriggers = lib.attrValues etcFiles;
    };

    # Group used by the udev rules for hardware access
    users.groups.omen-hw = { };

    # Kernel
    boot.kernelModules = [ "hp-wmi" "hp-omen-extra" ];
    boot.extraModulePackages = [ omen-driver ];

    # ryzen_smu driver: lets ryzenadj talk to the SMU on modern kernels
    # instead of /dev/mem (which the kernel restricts)
    hardware.cpu.amd.ryzen-smu.enable = true;
  };
}

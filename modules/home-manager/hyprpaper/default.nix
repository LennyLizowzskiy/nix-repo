{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.hyprpaper;

  wallpaperType = mkOptionType {
    name = "hyprpaper wallpaper setting";
    check = (as: (as ? "monitor") && (as ? "image"));
  };
in
{
  options = {
    programs.hyprpaper = {
      enable = mkEnableOption "Hyprpaper - Wayland wallpaper utility";

      systemd = {
        enable = mkEnableOption "autostart service for Hyprpaper";

        target = mkOption {
          type = types.str;
          default = "graphical-session.target";
          example = "hyprland-session.target";
          description = ''
            The systemd target that will automatically start the Hyprpaper service.
          '';
        };
      };

      settings = with types; {
        preload = mkOption {
          type = listOf path;
          default = [ ];
          description = ''
            Wallpaper images that should be preloaded into memory 
          '';
          example = [ ./wallpapers/tensura.png ];
        };

        wallpapers = mkOption {
          type = listOf wallpaperType;
          default = [ ];
          description = ''
            Wallpaper to monitor mapper
          '';
        };

        extraConfig = mkOption {
          type = str;
          default = "Check https://github.com/hyprwm/hyprpaper#usage for info";
          example = ''
            newConfigOption = foo,bar
          '';
        };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.hyprpaper
    ];

    systemd.user.services.hyprpaper = mkIf cfg.systemd.enable {
      Unit = {
        Description = "autostart service for Hyprpaper";
        Documentation = "https://github.com/hyprwm/hyprpaper";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = { 
        WantedBy = [ 
          cfg.systemd.target 
        ]; 
      };
    };

    xdg.configHome = mkIf cfg.enable {
      "hypr/hyprpaper.conf".text = ''
        # Auto-generated by Nix home-manager module

        # hyprpaper.settings.preload
        ${(lists.foldr cfg.settings.preload (acc: v: acc + "preload = ${v}\n") "")}

        # hyprpaper.settings.wallpapers
        ${(lists.foldr cfg.settings.wallpapers (acc: v: acc + "wallpaper = ${v.monitor},${v.image}\n") "")}

        # hyprpaper.settings.extraConfig
        ${cfg.settings.extraConfig}
      '';
    };
  };
}

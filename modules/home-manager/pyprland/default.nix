{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.pyprland;
  
  tomlFormatter = pkgs.formats.toml { };
in
{
  options = {
    programs.pyprland = {
      enable = mkEnableOption "Pyprland - Hyprland plugin framework";

      systemd.enable = mkEnableOption "Autostart service for Pyprland";

      settings = mkOption {
        type = types.attrs;
        description = "Check https://github.com/hyprland-community/pyprland/wiki/Getting-started#configuring for info";
        default = { };
        example = {
          pyprland.plugins = [ "workspaces_follow_focus" ];
          
          workspaces_follow_focus = {
            max_workspaces = 9;
          };
        };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.pyprland
    ];

    systemd.user.services.pyprland = mkIf cfg.systemd.enable {
      Unit = {
        Description = "Autostart service for Pyprland";
        Documentation = "https://github.com/hyprland-community/pyprland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.pyprland}/bin/pypr";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = { 
        WantedBy = [ 
          "hyprland-session.target" 
        ]; 
      };
    };
    

    xdg.configHome = mkIf cfg.enable {
      "hypr/pyprland.toml" = {
        source = tomlFormatter.generate "pyprland_config.toml" cfg.settings;
        onChange = ''
          ${pkgs.pyprland}/bin/pypr reload 
        '';
      };
    };
  };
}
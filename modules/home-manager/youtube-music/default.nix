{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.youtube-music;
in
{
  options = {
    programs.youtube-music = {
      enable = mkEnableOption "unofficial Electron client for Youtube.Music";
    
      settings = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.youtube-music
    ];

    xdg.configFile."Youtube Music/config.json".text = builtins.toJSON cfg.settings;
  };
}
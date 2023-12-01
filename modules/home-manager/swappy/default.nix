{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.swappy;

  generateConf = (attrs: (generators.toINI {} { Default = attrs; }));
in
{
  options = {
    programs.swappy = {
      enable = mkEnableOption "swappy - Wayland native snapshot editing tool";

      settings = mkOption rec {
        type = types.attrs;
        description = "Check https://github.com/jtheoof/swappy#config for info";
        default = {
          save_dir = "$HOME/Desktop";
          line_size = 5;
          text_size = 20;
          text_font = "sans-serif";
        };
        example = default;
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.swappy
    ];

    xdg.configHome = mkIf cfg.enable {
      "/swappy/config".text = generateConf cfg.settings;
    };
  };
}

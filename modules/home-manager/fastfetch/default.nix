{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.fastfetch;
in
{
  options = {
    programs.fastfetch = {
      enable = mkEnableOption "fastfetch - quick system information fetcher";
    
      settings = mkOption {
        type = types.attrs;
        description = "Check https://github.com/fastfetch-cli/fastfetch/wiki/Configuration for info";
        default = { };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.fastfetch
    ];

    xdg.configFile = mkIf cfg.enable {
      "fastfetch/config.jsonc".text = builtins.toJSON cfg.settings;
    };
  };
}
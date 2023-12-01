{ pkgs, config, ... }:

with lib;

let
  cfg = config.programs.fastfetch;
in
{
  options = {
    programs.fastfetch = {
      enable = mkEnableOption "fastfetch - quick system information fetcher";
    
      settings = {
        types = types.attrs;
        description = "Check https://github.com/fastfetch-cli/fastfetch/wiki/Configuration for info";
        default = { };
      };
    };
  };

  config = {
    xdg.configFile = mkIf cfg.enable {
      "fastfetch/config.jsonc".source = builtins.toJSON cfg.settings;
    };
  };
}
{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.micro;
in
{
  options = {
    programs.micro.plugins = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of dirs containing files in order as described in https://github.com/zyedidia/micro/blob/master/runtime/help/plugins.md
      '';
      example = [ pkgs.microPlugins.filemanager ];
    };
  };

  config = {
    xdg.configHome = mkIf cfg.enable (
      builtins.listToAttrs (forEach cfg.plugins (p:
        { name = "/micro/plug/${p.name}"; value = { source = p.out; }; }
      ))
    );
  };
}

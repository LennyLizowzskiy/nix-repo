{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.tofi;

  generateNoHeadIni = (attrs: 
    (generators.toINIWithGlobalSection { mkSectionName = (name: "# ${name}"); } { globalSection = attrs; })
  );
in
{
  options = {
    programs.tofi = {
      enable = mkEnableOption "tofi - dynamic menu for Wayland";

      settings = mkOption {
        type = types.attrs;
        description = "Check https://github.com/philj56/tofi/blob/master/doc/config for info";
        default = { };
        example = {
          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          padding-left = "35%";
          padding-top = "35%";
          result-spacing = "25";
          num-results = "5";
          font = "monospace";
          background-color = "#000A";
        };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.tofi
    ];

    xdg.configFile = mkIf cfg.enable {
      "tofi/config".text = generateNoHeadIni cfg.settings;
    };
  };
}

{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.lite-xl;

  luaImport = mkOptionType {
    name = "Lua import";
    check = (as: (as ? "name") && (as ? "module"));
  };
in
{
  options = {
    programs.lite-xl = {
      enable = mkEnableOption "Lite XL - lightweight text editor";

      settings = with types; {
        imports = mkOption {
          type = listOf luaImport;
          default = [  ];
          description = ''
            Lua imports
          '';
          example = [ 
            {  
              name = "keymap";
              module = "core.keymap";
            }
          ];
        };

        extraConfig = mkOption {
          type = str;
          default = "";
          description = ''
            Lite-XL configuration in Lua
          '';
          example = ''
            keymap.add { ["ctrl+escape"] = "core:quit" }
          '';
        };
      };
    };
  };

  config = {
    xdg.configFile = mkIf cfg.enable {
      "lite-xl/init.lua".text = ''
        -- Auto-generated by Nix home-manager module
      
        -- programs.lite-xl.settings.imports
        ${(lists.foldr cfg.settings.imports (acc: v: acc + "local ${v.name} = require(\"${v.module}\")\n") "")}

        -- programs.lite-xl.settings.extraConfig
        ${cfg.extraConfig}
      '';
    };
  };
}

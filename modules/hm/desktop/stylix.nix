{ config, osConfig, lib, ... }: 

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.desktop.stylix.enable {

        stylix.enable = true;
        stylix = {
            targets.librewolf.profileNames = lib.mkIf config.programs.librewolf.enable [ 
                osConfig.modules.system.username
            ];

            targets.hyprland.enable = false;

            targets.neovim.enable = false;

            targets.vesktop.enable = false;
        };
    };
}

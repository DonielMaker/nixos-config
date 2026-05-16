{ config, lib, modules, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.desktop.stylix;
in

{
    options.modules.desktop.stylix.enable = mkEnableOption "Enable Stylix";

    config = mkIf cfg.enable {

        stylix.enable = true;
        stylix = {
            targets.librewolf.profileNames = lib.mkIf config.programs.librewolf.enable [ 
                modules.system.username
            ];

            targets.hyprland.enable = false;

            targets.neovim.enable = false;

            targets.vesktop.enable = false;
        };

        gtk.gtk4.theme = config.gtk.theme;
    };
}

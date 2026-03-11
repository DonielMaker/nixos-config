{config, lib, ...}: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.hm.stylix;
in

{
    options.modules.hm.stylix.enable = mkEnableOption "Enable Stylix";

    config = mkIf cfg.enable {

           stylix.enable = true;
           stylix = {
               targets.librewolf.profileNames = lib.mkIf config.programs.librewolf.enable [ 
                   config.modules.hm.username 
               ];
               targets.hyprland.enable = false;
               targets.neovim.enable = false;
           };
    };
}

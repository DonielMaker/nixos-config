{config, lib, ...}: 

let
    module = "Stylix";
    cfg = config.modules.hm.stylix;
in with lib;

{
    options.modules.hm.stylix.enable = mkEnableOption "Enable ${module}";

    config = mkIf cfg.enable {

           stylix.enable = true;
           stylix = {
               targets.librewolf.profileNames = lib.mkIf config.programs.librewolf.enable [ config.modules.hm.username ];
               targets.hyprland.enable = false;
               targets.neovim.enable = false;
           };
    };
}

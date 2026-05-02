{ config, lib, ...}:

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.hm.obsidian;
in

{
    options.modules.hm.obsidian.enable = mkEnableOption "Enable Obsidian";

    config = mkIf cfg.enable {
        programs.obsidian.enable = true;
    };
}

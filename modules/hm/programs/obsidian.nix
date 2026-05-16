{ config, lib, ... }:

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.obsidian;
in

{
    options.modules.programs.obsidian.enable = mkEnableOption "Enable Obsidian";

    config = mkIf cfg.enable {
        programs.obsidian.enable = true;
    };
}

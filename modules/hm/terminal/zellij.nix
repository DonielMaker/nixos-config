{ config, lib, ...}:

let
    module = "Zellij";
    cfg = config.modules.hm.zellij;
in with lib;

{
    options.modules.hm.zellij.enable = mkEnableOption "Enable ${module}";

    config = mkIf cfg.enable {

        programs.zellij.enable = true;
    };
}

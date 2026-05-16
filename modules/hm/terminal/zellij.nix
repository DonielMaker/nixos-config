{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.zellij;
in

{
    options.modules.terminal.zellij.enable = mkEnableOption "Enable Zellij";

    config = mkIf cfg.enable {

        # Config tbi
        programs.zellij.enable = true;
    };
}

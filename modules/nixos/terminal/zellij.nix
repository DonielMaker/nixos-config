{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.zellij;
in

{
    options.modules.terminal.zellij.enable = mkEnableOption "Enable Zellij";

    config.home-manager.users.${config.modules.system.username} = mkIf cfg.enable {

        programs.zellij.enable = true;
    };
}

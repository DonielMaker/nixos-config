{ config, lib, modules, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.git;
in

{
    options.modules.terminal.git.enable = mkEnableOption "Enable git";

    config = mkIf cfg.enable {

        programs.git.enable = true;
        programs.git.settings = {
            user.name = modules.system.username;
            user.email = modules.system.mail;
        };
    };
}

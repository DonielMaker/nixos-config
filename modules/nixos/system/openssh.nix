{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.system.openssh;
in

{
    options.modules.system.openssh.enable = mkEnableOption "Enable Openssh";

    config = mkIf cfg.enable {

        security.sudo.execWheelOnly  =  true;
        services.openssh.enable = true;
        services.openssh.settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
        };
    };
}

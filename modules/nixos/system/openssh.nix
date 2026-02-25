{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.system.openssh;
in

{
    options.modules.system.openssh.enable = mkEnableOption "Enable Openssh";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.system.enable)
        ];

        security.sudo.execWheelOnly  =  true;
        services.openssh.enable = true;
        services.openssh.settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
        };
    };
}

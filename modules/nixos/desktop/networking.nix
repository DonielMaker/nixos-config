{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.networking;
in

{
    options.modules.desktop.networking.enable = mkEnableOption "Enable Networking";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        networking.networkmanager.enable = true;
        networking.hostName = config.modules.system.hostname;
    };
}

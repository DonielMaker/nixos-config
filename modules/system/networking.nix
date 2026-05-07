{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.system.networking;
in

{
    options.modules.system.networking.enable = mkEnableOption "Enable Networking";

    config = mkIf cfg.enable {

        networking.networkmanager.enable = true;
        networking.hostName = config.modules.system.hostname;
        networking.search = [ "thematt.net" ];
    };
}

{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.beszel-hub;
in

{
    options.modules.server.beszel-hub.enable = mkEnableOption "Enable Beszel Hub";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 8090 ];

        services.beszel.hub.enable = true;
        services.beszel.hub = {
            host = "0.0.0.0";
            environment.APP_URL = "https://beszel.${config.modules.server.domain}";
        };
    };
}

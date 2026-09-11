{ config, lib, ...}:

let
    inherit (lib) mkIf;
    domain = config.networking.domain;
in

{
    config = mkIf config.modules.server.monitoring.enable {

        networking.firewall.allowedTCPPorts = [ 9090 ];

        services.prometheus.enable = true;
        services.prometheus = {
            webExternalUrl = "https://prometheus.${domain}";
            extraFlags = [ "--web.enable-remote-write-receiver" ]; # Allows pushing to prometheus aswell as pulling
            port = 9090;
            checkConfig = "syntax-only";

            # Declare which Alertmanagers exists (Only useful for HA. Here we have only one)
            alertmanagers = [
                {
                    scheme = "https";
                    static_configs = [{ targets = [ "alertmanager.${domain}" ]; }];
                }
            ];
            
            # The Alerts
            ruleFiles = [
                ./embedded-exporter.yml
                ./node-exporter.yml
            ];
        };
    };
}

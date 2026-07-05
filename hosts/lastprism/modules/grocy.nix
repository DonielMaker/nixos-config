{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.grocy;
in

{
    options.modules.server.grocy.enable = mkEnableOption "Enable Grocy";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 9283 ];

        systemd.tmpfiles.rules = [
            "d /storage/grocy 770 1000 100 -"
        ];

        virtualisation.oci-containers.backend = "podman";
        virtualisation.oci-containers.containers = {
            grocy = {
                image = "lscr.io/linuxserver/grocy:4.6.0";
                autoStart = true;
                environment = {
                    PUID="1000";
                    PGID="1000";
                    TZ="Europe/Berlin";
                };
                volumes = [ "/storage/grocy:/config" ];
                ports = [ "9283:80" ];
            };
        };
    };
}

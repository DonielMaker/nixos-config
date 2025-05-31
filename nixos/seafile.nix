{...}:

{
    services.seafile = {
        enable = true;
        seahubAddress = "0.0.0.0:8000";

        adminEmail = "daniel.schmidt0204@gmail.com";
        initialAdminPassword = "Changeme";

        ccnetSettings.General.SERVICE_URL = "https://seafile.lastprism.thematt.net";

        seafileSettings = {
            fileserver = {
                host = "0.0.0.0";
                port = 8082;
            };
        };

        dataDir = "/var/lib/seafile";
    };

    systemd.tmpfiles.rules = [
        "Z /var/lib/seafile 0770 seafile seafile -"
    ];

    networking.firewall.allowedTCPPorts = [ 8000 8082 ];
}

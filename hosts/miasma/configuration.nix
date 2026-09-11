{ config, sLib, ... }:

{

    imports = [ ./hardware-configuration.nix ./disko.nix ] ++ sLib.nixFiles ./modules;

    networking.hostName = "miasma";
    
    settings.username = "donielmaker";

    modules = {
        system = {
            enable = true;

            user.enable = true;

            systemd-boot.enable = true;

            openssh.enable = true;

            gc.enable = true;
        };

        server = {
            enable = true;
            qemuGuest.enable = true;

            alloy.enable = true;
            authelia.enable = true;
            caddy.enable = true;
            homepage-dashboard.enable = true;
            monitoring.enable = true;
            vaultwarden.enable = true;
        };
    };

    age.secrets = let

        authelia-main = {
            mode = "440";
            owner = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
        };

        alertmanager = {
            mode = "440";
            owner = "alertmanager";
            group = "alertmanager";
        };

        grafana = {
            mode = "440";
            owner = "grafana";
            group = "grafana";
        };
    in

    {
        authelia-jwtSecret = {
            inherit (authelia-main) mode owner group;
            file = ./secrets/authelia/jwtSecret.age;
        };

        authelia-storageEncryptionKey = {
            inherit (authelia-main) mode owner group;
            file = ./secrets/authelia/storageEncryptionKey.age;
        };

        authelia-sessionSecret = {
            inherit (authelia-main) mode owner group;
            file = ./secrets/authelia/sessionSecret.age;
        };

        authelia-oidcIssuerPrivateKey = {
            inherit (authelia-main) mode owner group;
            file = ./secrets/authelia/oidcIssuerPrivateKey.age;
        };

        alertmanager-smtpPassword = {
            inherit (alertmanager) mode owner group;
            file = ./secrets/alertmanager-smtpPassword.age;
        };

        grafana-secretKey = {
            inherit (grafana) mode owner group;
            file = ./secrets/grafana/secretKey.age;
        };

        grafana-clientSecret = {
            inherit (grafana) mode owner group;
            file = ./secrets/grafana/clientSecret.age;
        };

        vaultwardenEnv.file = ./secrets/vaultwarden-env.age;

        cloudflare-dnsApiToken.file = ./secrets/cloudflare-dnsApiToken.age;
    };

    services.technitium-dns-server.enable = true;
    services.technitium-dns-server.openFirewall = true;

    system.stateVersion = "26.05"; # Just don't
}

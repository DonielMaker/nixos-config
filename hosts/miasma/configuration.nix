{config, lib, ...}:

{

    imports = [ ./hardware-configuration.nix ./disko.nix ] ++ lib.filesystem.listFilesRecursive ./modules;

    modules = {
        system = {
            enable = true;
            hostname = "miasma";
            username = "donielmaker";

            user.enable = true;

            systemd-boot.enable = true;

            openssh.enable = true;
            networking.enable = true;

            gc.enable = true;
        };

        server = {
            enable = true;
            domain = "thematt.net";
            qemuGuest.enable = true;

            authelia.enable = true;
            caddy.enable = true;
            homepage-dashboard.enable = true;
            vaultwarden.enable = true;
        };
    };

    age.secrets = let

        authelia-main = {
            mode = "440";
            owner = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
        };

        beszel = {
            mode = "440";
            owner = "beszel-agent";
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

        vaultwardenEnv.file = ./secrets/vaultwarden-env.age;

        cloudflare-dnsApiToken.file = ./secrets/cloudflare-dnsApiToken.age;

        beszel-key = {
            inherit (beszel) mode owner;
            file = ./secrets/beszel/key.age;
        };

        beszel-token = {
            inherit (beszel) mode owner;
            file = ./secrets/beszel/token.age;
        };
    };

    services.technitium-dns-server.enable = true;
    services.technitium-dns-server.openFirewall = true;

    services.beszel.agent.enable = true;
    services.beszel.agent = {
        openFirewall = true;
        smartmon.enable = true;
        environment = {
            FILESYSTEM = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
            HUB_URL = "https://beszel.thematt.net";
            KEY_FILE = config.age.secrets.beszel-key.path;
            TOKEN_FILE = config.age.secrets.beszel-token.path;
        };
    };

    system.stateVersion = "25.05"; # Just don't
}

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
        };

        server = {
            enable = true;
            domain = "thematt.net";
            qemuGuest.enable = true;

            authelia.enable = true;
            bind.enable = true;
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
    };

    system.stateVersion = "25.05"; # Just don't
}

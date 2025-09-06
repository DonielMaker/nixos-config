{ inputs, pkgs, system, username, config, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        # System
        bootloader
        networking
        settings
        user

        caddy
        authelia
        lldap
    ];

    # Enable common container config files in /etc/containers
    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];

    networking.firewall.allowedTCPPorts = [ 28981 8080 9200 9300 9980 8000];
    services.navidrome.enable = true;
    services.navidrome.openFirewall = true;
    services.navidrome.settings = { 
        Address = "0.0.0.0";
        MusicFolder = "/storage/music"; 
    };

    services.paperless.enable = true;
    services.paperless.address = "0.0.0.0";
    services.paperless.settings = {
        PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://paperless.thematt.net";
    };

    age.secrets = let

        authelia = {
            mode = "440";
            owner = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
        };
    in

    {
        jwtSecret = {
            inherit (authelia) mode owner group;
            file = ./secrets/jwtSecret.age;
        };

        storageEncryptionKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/storageEncryptionKey.age;
        };
        sessionSecret = {
            inherit (authelia) mode owner group;
            file = ./secrets/sessionSecret.age;
        };
        autheliaLldapPassword = {
            inherit (authelia) mode owner group;
            file = ./secrets/autheliaLldapPassword.age;
        };
        autheliaJwksKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/autheliaJwksKey.age;
        };

        cloudflareDnsApiToken.file = ./secrets/cloudflareDnsApiToken.age;
    };

    security.sudo.execWheelOnly  =  true;

    services.openssh.enable = true;
    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    nix.settings.trusted-users = [ "donielmaker" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
        docker-compose
    ];

    system.stateVersion = "25.11"; # Just don't
}

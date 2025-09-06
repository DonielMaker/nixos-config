{ inputs, pkgs, system, config, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.copyparty.nixosModules.default

        bootloader
        networking
        settings
        user
        docker
        openssh

        lldap

        ./modules/caddy.nix
        ./modules/authelia.nix
    ];

    # paperless, opencloud, copyparty
    networking.firewall.allowedTCPPorts = [ 28981 9200 3923 ];

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

    nixpkgs.overlays = [
        inputs.copyparty.overlays.default
    ];

    services.copyparty.enable = true;
    services.copyparty = {
        settings = {
            i = "0.0.0.0";
            z = true;
            e2dsa = true;
            e2ts = true;
        };

        accounts = {
            donielmaker.passwordFile = "/run/keys/copyparty/don_password";
        };

        volumes = {
            "/" = {
                path = "/storage/copyparty";
                access.rwmda = "donielmaker";
            };
        };
    };

    # Navidrome: A Music server which uses the subsonic protocol to send content to clients
    services.navidrome.enable = true;
    services.navidrome.openFirewall = true;
    services.navidrome.settings = { 
        Address = "0.0.0.0";
        MusicFolder = "/storage/music"; 
    };

    # Paperless: A Document server with plenty of features (ocr, file conversion, editing, etc.)
    services.paperless.enable = true;
    services.paperless.address = "0.0.0.0";
    services.paperless.settings = {
        PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://paperless.thematt.net";
    };

    nix.settings.trusted-users = [ "donielmaker" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}

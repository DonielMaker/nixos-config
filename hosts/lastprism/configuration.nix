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

    # 8080 = erp-next
    networking.firewall.allowedTCPPorts = [ 28981 8080 9200 9300 9980 8000];
    # services.paperless.enable = true;
    # services.paperless.address = "0.0.0.0";
    # services.paperless.settings = {
    #     PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://paperless.thematt.net";
    # };

    age.secrets = let
        authelia-owner = config.services.authelia.instances.main.user;
        authelia-group = config.services.authelia.instances.main.group;
    in

    {
        jwtSecret = {
            file = ./secrets/jwtSecret.age;
            mode = "440";
            owner = authelia-owner;
            group = authelia-group;
        };
        storageEncryptionKey = {
            file = ./secrets/storageEncryptionKey.age;
            mode = "440";
            owner = authelia-owner;
            group = authelia-group;
        };
        sessionSecret = {
            file = ./secrets/sessionSecret.age;
            mode = "440";
            owner = authelia-owner;
            group = authelia-group;
        };
        autheliaLldapPassword = {
            file = ./secrets/autheliaLldapPassword.age;
            mode = "440";
            owner = authelia-owner;
            group = authelia-group;
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

{ inputs, pkgs, system, myLib, config, ...}:

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
    ];

    system.stateVersion = "25.11"; # Just don't
}

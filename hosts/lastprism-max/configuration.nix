{ inputs, pkgs, system, username, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        ./caddy.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        # System
        bootloader
        networking
        settings
        user
    ];

    networking.firewall.allowedTCPPorts = [ 8080 ];

    boot.supportedFilesystems = [ "zfs" ]; 
    networking.hostId = "24b5029d";

    age.secrets = let
        # authelia-owner = config.services.authelia.instances.main.user;
        # authelia-group = config.services.authelia.instances.main.group;
    in

    {
    #     jwtSecret = {
    #         file = ./secrets/jwtSecret.age;
    #         mode = "440";
    #         owner = authelia-owner;
    #         group = authelia-group;
    #     };
    #     storageEncryptionKey = {
    #         file = ./secrets/storageEncryptionKey.age;
    #         mode = "440";
    #         owner = authelia-owner;
    #         group = authelia-group;
    #     };
    #     sessionSecret = {
    #         file = ./secrets/sessionSecret.age;
    #         mode = "440";
    #         owner = authelia-owner;
    #         group = authelia-group;
    #     };
    #     autheliaLldapPassword = {
    #         file = ./secrets/autheliaLldapPassword.age;
    #         mode = "440";
    #         owner = authelia-owner;
    #         group = authelia-group;
    #     };
        ipv64DnsApiToken.file = ./secrets/ipv64DnsApiToken.age;
    };

    security.sudo.execWheelOnly  =  true;

    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;

    services.openssh.enable = true;
    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    users.users.${username} = {
        extraGroups = ["docker"];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQCbrIxOgzRpoEYyb/SaoDhM5i93wWJ8biH/f8ygT deuyanon@SPC-01"
        ];
    };

    nix.settings.trusted-users = [ "donielmaker" "deuyanon" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
        docker-compose
    ];

    system.stateVersion = "25.05"; # Just don't
}

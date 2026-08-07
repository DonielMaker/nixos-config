{config, lib, ...}:

{

    imports = [ ./hardware-configuration.nix ./disko.nix ] ++ lib.filesystem.listFilesRecursive ./modules;

    modules = {
        system = {
            enable = true;
            hostname = "lastprism";
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

            homebox.enable = true;
            navidrome.enable = true;
            paperless.enable = true;
            sftpgo.enable = true;
        };
    };

    age.secrets = let

        sftpgo = {
            owner = config.services.sftpgo.user;
            group = config.services.sftpgo.group;
            mode = "440";
        };

    in 

    {

        homebox-envFile.file = ./secrets/homebox-envFile.age;

        paperless-envFile.file = ./secrets/paperless-envFile.age;

        sftpgo-clientSecret = {
            inherit (sftpgo) owner group mode;
            file = ./secrets/sftpgo-clientSecret.age;
        };
    };

    system.stateVersion = "25.11"; # Just don't
}

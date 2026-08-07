{config, lib, pkgs, ...}:

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

            gc.enable = true;
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

        beszel = {
            mode = "440";
            owner = "beszel-agent";
        };
    in 

    {

        homebox-envFile.file = ./secrets/homebox-envFile.age;

        paperless-envFile.file = ./secrets/paperless-envFile.age;

        sftpgo-clientSecret = {
            inherit (sftpgo) owner group mode;
            file = ./secrets/sftpgo-clientSecret.age;
        };

        beszel-key = {
            inherit (beszel) mode owner;
            file = ./secrets/beszel/key.age;
        };

        beszel-token = {
            inherit (beszel) mode owner;
            file = ./secrets/beszel/token.age;
        };
    };

    services.beszel.agent.enable = true;
    services.beszel.agent = {
        openFirewall = true;
        smartmon.enable = true;
        environment = {
            FILESYSTEM = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
            EXTRA_FILESYSTEMS = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1";
            HUB_URL = "https://beszel.thematt.net";
            KEY_FILE = config.age.secrets.beszel-key.path;
            TOKEN_FILE = config.age.secrets.beszel-token.path;
        };
    };

    system.stateVersion = "25.11"; # Just don't
}

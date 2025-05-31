{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko

        # System
        bootloader
        networking
        settings
        user
    ];

    services.openssh.enable = true;
    security.sudo.execWheelOnly  =  true;

    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    services.seafile = {
        enable = true;
        seahubAddress = "0.0.0.0:8000";

        adminEmail = "daniel.schmidt0204@gmail.com";
        initialAdminPassword = "Changeme";

        ccnetSettings.General.SERVICE_URL = "https://seafile.lastprism.thematt.net";

        seafileSettings = {
            fileserver = {
                host = "0.0.0.0";
                port = 8082;
            };
        };

        dataDir = "/var/lib/seafile";
    };

    networking.firewall.allowedTCPPorts = [ 22 8082 8000 ];

    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;

    fileSystems."/var/lib/seafile" = {
        device = "/dev/sda";
        fsType = "ext4";
        options = [ "nofail" ];
    };

    systemd.tmpfiles.rules = [
        "Z /var/lib/seafile 0770 seafile seafile -"
    ];

    nix.settings.trusted-users = [ "donielmaker" ];

    # Any extra Packages
    environment.systemPackages = with pkgs; [
        vim
        git
    ];

    system.stateVersion = "24.11"; # Just don't
}

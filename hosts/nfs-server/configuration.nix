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

        seafile
    ];

    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh.enable = true;
    security.sudo.execWheelOnly  =  true;

    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;

    fileSystems."/var/lib/seafile" = {
        device = "/dev/sda";
        fsType = "ext4";
        options = [ "nofail" ];
    };

    nix.settings.trusted-users = [ "donielmaker" ];

    # Any extra Packages
    environment.systemPackages = with pkgs; [
        vim
        git
    ];

    system.stateVersion = "24.11"; # Just don't
}

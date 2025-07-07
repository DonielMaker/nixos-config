{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko
        ./disko.nix

        # System
        bootloader
        networking
        settings
        user
    ];

    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh.enable = true;
    security.sudo.execWheelOnly = true;

    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    nix.settings.trusted-users = [ "donielmaker" ];

    # Any extra Packages
    environment.systemPackages = with pkgs; [
        vim
        git
    ];

    system.stateVersion = "24.11"; # Just don't
}

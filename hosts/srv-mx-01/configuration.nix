{ inputs, pkgs, system, username, ...}:

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

        docker 
        openssh

        ./modules/caddy.nix
    ];

    # erpnext
    networking.firewall.allowedTCPPorts = [ 8080 ];

    boot.supportedFilesystems = [ "zfs" ]; 
    networking.hostId = "24b5029d";

    age.secrets = {
        ipv64DnsApiToken.file = ./secrets/ipv64DnsApiToken.age;
    };

    users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQCbrIxOgzRpoEYyb/SaoDhM5i93wWJ8biH/f8ygT deuyanon@SPC-01"
    ];

    nix.settings.trusted-users = [ "donielmaker" "deuyanon" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.05"; # Just don't
}

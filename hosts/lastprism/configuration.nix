{ inputs, pkgs, system, myLib, ...}:

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

        # TODO: add the lastprism system to the secrets.nix
        caddy
        authelia
        lldap
    ];

    age.secrets = myLib.getSecrets ./secrets;

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

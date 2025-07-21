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

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
    ];

    system.stateVersion = "25.11"; # Just don't
}

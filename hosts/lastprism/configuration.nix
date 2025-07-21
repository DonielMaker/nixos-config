{ inputs, pkgs, system, config, myLib, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        # System
        bootloader
        networking
        settings
        user

        zsh

        caddy
        authelia
        lldap
    ];

    age.secrets = myLib.getSecrets ./secrets;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
    ];

    system.stateVersion = ""; # Just don't
}

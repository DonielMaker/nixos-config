{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        settings
        networking
        bootloader
        user
        disko
    ];

    environment.systemPackages = with pkgs; [];

    system.stateVersion = throw "system.stateVersion not configured"; # Just don't
}

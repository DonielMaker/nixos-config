{inputs, pkgs, pkgs-stable, arch, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix

        system.limine
        system.intel

        system.settings
        system.user

        system.openssh
        system.networking

        desktop.graphics
        desktop.hyprland
        desktop.regreet

        desktop.bluetooth
        desktop.sound

        desktop.zsh
        desktop.stylix
    ];

    services.upower.enable = true;
    services.tlp.enable = true;

    programs.localsend.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${arch}.default

        just
        typst

        zathura
        brave
        vlc
        signal-desktop
        gimp
        obs-studio
        pkgs-stable.geeqie

        home-manager
    ];

    system.stateVersion = "25.05"; # Just don't
}

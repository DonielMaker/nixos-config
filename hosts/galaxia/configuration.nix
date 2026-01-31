{inputs, pkgs, pkgs-stable, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix

        limine
        settings
        user
        openssh
        networking

        graphics
        hyprland
        intel

        regreet
        stylix

        bluetooth
        sound

        zsh
    ];

    services.upower.enable = true;
    services.tlp.enable = true;

    programs.localsend.enable = true;

    environment.systemPackages = with pkgs; [

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

{inputs, pkgs, pkgs-stable, arch, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        limine
        settings
        user
        openssh
        networking

        graphics
        hyprland
        amd

        regreet
        stylix

        sound
        gigabyte
        coolercontrol
        bluetooth
        steam

        zsh
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

    services.flatpak.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    virtualisation.waydroid.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${arch}.default
        inputs.quickshell.packages.${arch}.quickshell

        just
        scarlett2
        alsa-scarlett-gui
        pkgs-stable.geeqie

        brave 
        gimp
        pkgs-stable.rustdesk
        signal-desktop
        vlc
        kdePackages.kdenlive
        vesktop
        obs-studio
        orca-slicer

        prismlauncher
        heroic
        steam
        everest-mons
        xclicker
        owmods-gui
        owmods-cli
        protonplus


        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

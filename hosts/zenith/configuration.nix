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

    networking.firewall.allowedTCPPorts = [ 5900 ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

    services.flatpak.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    virtualisation.waydroid.enable = true;

    programs.wayvnc.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${arch}.default
        inputs.quickshell.packages.${arch}.quickshell

        scarlett2
        alsa-scarlett-gui

        brave 
        pkgs-stable.geeqie
        gimp
        signal-desktop
        vlc
        kdePackages.kdenlive
        vesktop
        obs-studio
        orca-slicer
        librewolf
        drawio

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

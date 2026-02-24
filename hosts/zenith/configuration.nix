{config, inputs, pkgs, pkgs-stable, arch, username, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix

        system.limine
        system.amd

        system.settings
        system.user

        system.openssh
        system.networking

        desktop.graphics
        desktop.hyprland
        # desktop.regreet

        desktop.gigabyte
        desktop.coolercontrol
        desktop.steam

        desktop.sound
        desktop.bluetooth

        desktop.stylix
        desktop.zsh
    ];

    networking.firewall.allowedTCPPorts = [ 5900 ];
    networking.nameservers = [ "10.10.12.10" "10.10.110.10" "1.1.1.1" ];
    networking.search = [ "thematt.net, soluttech.uk" ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

    programs.dms-shell.enable = true;
    programs.dms-shell = {
        systemd.enable = true;
        systemd.restartIfChanged = true;
        enableDynamicTheming = false;
        enableAudioWavelength = false;
    };

    services.displayManager.dms-greeter.enable = true;
    services.displayManager.dms-greeter = {
        compositor.name = "hyprland";
        configHome = config.users.users.${username}.home;
    };

    services.flatpak.enable = true;

    security.pam.services.${username}.kwallet.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    programs.wayvnc.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${arch}.default

        scarlett2
        alsa-scarlett-gui

        brave 
        geeqie
        gimp
        signal-desktop
        vlc
        pkgs-stable.kdePackages.kdenlive
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

        kdePackages.kwallet

        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

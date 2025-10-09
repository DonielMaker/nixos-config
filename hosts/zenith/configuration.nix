{ inputs, pkgs, pkgs-stable, system, config, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        bootloader
        networking
        settings
        user

        graphics
        amd

        regreet
        stylix

        sound
        gigabyte
        coolercontrol
        bluetooth

        # neovim
        steam
        zsh
    ];

    services.xserver.xkb.layout = "us";

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

    services.flatpak.enable = true;

    boot.plymouth.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    services.openssh.enable = true;

    services.resolved.enable = true;
    services.resolved.domains = [ "thematt.net" ];
    networking.networkmanager.dns = "systemd-resolved";

    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };


    age.secrets = {
       wireguard-priKey.file = ./secrets/wireguard-priKey.age;
       wireguard-shrKey.file = ./secrets/wireguard-shrKey.age;
    };

    virtualisation.waydroid.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        protonplus
        gnome-calendar
        gnome-contacts
        gimp
        # rustdesk
        signal-desktop
        vlc
        kdePackages.kdenlive
        vesktop
        obs-studio
        geeqie

        prismlauncher
        heroic
        steam
        everest-mons
        xclicker

        orca-slicer
        nautilus
        qt6ct


        evolution-data-server
        hyprpolkitagent
        qt6ct
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

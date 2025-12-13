{ hostname, inputs, pkgs, system, ...}:

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

    networking.hostName = hostname;
    networking.networkmanager.enable = true;
    services.resolved.enable = true;
    services.resolved.fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
    ];
    services.resolved.domains = [ "thematt.net" "soluttech.uk"];
    networking.networkmanager.dns = "systemd-resolved";
    networking.nameservers = [ "10.10.12.10" "10.10.110.10" ];

    services.xserver.xkb.layout = "us";

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_17;


    services.flatpak.enable = true;

    boot.plymouth.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    # services.printing.enable = true;
    # services.avahi = {
    #     enable = true;
    #     nssmdns4 = true;
    #     openFirewall = true;
    # };

    age.secrets = {
       wireguard-priKey.file = ./secrets/wireguard-priKey.age;
       wireguard-shrKey.file = ./secrets/wireguard-shrKey.age;
    };

    virtualisation.waydroid.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        just
        brave
        scarlett2
        alsa-scarlett-gui
        wireguard-tools
        protonplus
        gnome-calendar
        gnome-contacts
        gimp
        rustdesk
        signal-desktop
        vlc
        kdePackages.kdenlive
        vesktop
        obs-studio
        geeqie
        hyprshot

        prismlauncher
        heroic
        steam
        everest-mons
        xclicker

        orca-slicer
        nautilus

        wakeonlan
        hyprpolkitagent
        kdePackages.qt6ct
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

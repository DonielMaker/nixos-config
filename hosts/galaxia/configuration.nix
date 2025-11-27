{config, inputs, pkgs, system, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        # bootloader
        limine
        networking
        settings
        user
        openssh

        graphics
        intel

        regreet
        stylix

        bluetooth
        sound

        zsh
    ];

    services.xserver.xkb.layout = "de";

    services.upower.enable = true;
    services.tlp.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    age.secrets = {
       wireguard-priKey.file = ./secrets/wireguard-priKey.age;
    };

    programs.localsend.enable = true;

    networking.wg-quick.interfaces.wg0 = {
        address = [ "10.20.10.3/32" ];
        dns = [ "10.10.12.10, thematt.net" ];
        peers = [
            {
                allowedIPs = [ "10.20.10.0/24" "10.10.0.0/16" ];
                endpoint = "public.ipv64.de:51820";
                publicKey = "HS4sfxavdcVujCE9r0nJBdcaJgl7xg9Z3bGqFcfjq0w=";
            }
        ];
        privateKeyFile = config.age.secrets.wireguard-priKey.path;
    };

    environment.systemPackages = with pkgs; [
        inputs.quickshell.packages.${system}.quickshell
        inputs.ragenix.packages.${system}.default

        cairo
        atk
        glib
        gtk3
        pango
        dioxus-cli

        wireguard-tools
    
        zathura
        typst
        vlc
        signal-desktop
        orca-slicer
        nautilus
        geeqie

        home-manager
    ];

    system.stateVersion = "25.05"; # Just don't
}

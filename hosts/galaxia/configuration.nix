{config, inputs, pkgs, system, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        # System
        bootloader
        #limine
        networking
        settings
        user
        graphics
        intel
        regreet
        bluetooth
        sound
        stylix
        neovim
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
       wireguard-shrKey.file = ./secrets/wireguard-shrKey.age;
    };

    environment.etc."resolv.conf".text = ''
       search fritz.box thematt.net 
       nameserver 1.1.1.1
       options edns0
    '';

    programs.localsend.enable = true;

    services.openssh.enable = true;


    networking.wg-quick.interfaces.wg0 = {
        address = [ "10.10.20.3/32" ];
        # dns = [ "1.1.1.1, thematt.net" ];
        peers = [
            {
                allowedIPs = [ "10.10.0.0/16" ];
                endpoint = "public.ipv64.de:51820";
                publicKey = "DQ2yw5O4IPieIi048Qzr+8YyiLtnyZWMD6wTNSETxSE=";
                presharedKeyFile = config.age.secrets.wireguard-shrKey.path;
            }
        ];
        privateKeyFile = config.age.secrets.wireguard-priKey.path;
    };

    environment.systemPackages = with pkgs; [
        inputs.quickshell.packages.${system}.quickshell
        inputs.ragenix.packages.${system}.default

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

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

    services.resolved.enable = true;

    services.gvfs.enable = true;

    age.secrets = {
       wireguard-priKey.file = ./secrets/wireguard-priKey.age;
       wireguard-shrKey.file = ./secrets/wireguard-shrKey.age;
    };

    programs.localsend.enable = true;

    services.openssh.enable = true;

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

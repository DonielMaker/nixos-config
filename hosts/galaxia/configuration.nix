{inputs, pkgs, system, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        # bootloader
        networking
        settings
        user
        disko

        # Hyprland (and other graphics related stuff)
        graphics

        # Graphics driver
        intel
            # nvidia
            # amd

        # Display manager
        regreet
            # gdm
            # sddm

        # Hardware related
        bluethooth
            # fingerprint
        sound

        # Programs 
        neovim
            # openrgb
            # steam
        zsh
    ];

    services.upower.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "kitty";

    networking.search = [ "thematt.net" ];

    boot.loader.limine.enable = true;
    boot.loader.limine = {
        efiSupport = true;
        style = {
            wallpapers = [
                ./vladislav-klapin-o-SMjjGuP6c-unsplash.jpg            
            ];
            interface.resolution = "1920x1080";
            interface.branding = "I use NixOS btw";
            graphicalTerminal.background = "ff000000";
            graphicalTerminal.foreground = "c0caf5";
            graphicalTerminal.margin = 50;
        };
        maxGenerations = 50;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
        inputs.quickshell.packages.${system}.quickshell
        ferrishot
        zenity
        # Programs
        nautilus
        hyprpicker
        geeqie
        # Other
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

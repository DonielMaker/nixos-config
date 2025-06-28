{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        bootloader
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

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "kitty";

    networking.search = [ "thematt.net" ];

    environment.systemPackages = with pkgs; [
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

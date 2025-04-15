{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        settings
        networking
        bootloader
	    disko
        user

        # Programs
        neovim
        zsh

        # Modules
        sound
        graphics
        bluethooth
        sddm
        intel
    ];

    environment.systemPackages = with pkgs; [
        # Programs
        nemo
        hyprpicker
        geeqie
        (flameshot.override { enableWlrSupport = true; })
        # Other
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

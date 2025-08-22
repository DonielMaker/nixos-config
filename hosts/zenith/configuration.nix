{ inputs, pkgs, pkgs-stable, system, config, myLib, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        limine
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

        neovim
        steam
        zsh
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_15;

    services.flatpak.enable = true;

    boot.plymouth.enable = true;

    networking.networkmanager.insertNameservers = [ "10.10.12.2" ];

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";


    services.lact.enable = true;

    services.openssh.enable = true;

    age.secrets = myLib.getSecrets ./secrets;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        # geekbench_6
        signal-desktop
        upscaler
        obs-studio
        hyprpolkitagent

        # Gaming
        # xclicker
        protonup-qt
        lutris
        pkgs-stable.prismlauncher
        steam
        everest-mons

        # Programs
        ferrishot
        lm_sensors
        # gimp
        vlc
        kdePackages.kdenlive
        orca-slicer
        bambu-studio
        qt6ct
        vesktop
        nautilus
        hyprpicker
        geeqie
        alsa-scarlett-gui
        # Other
        xdg-desktop-portal
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

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

    programs.localsend.enable = true;

    services.lact.enable = true;

    services.openssh.enable = true;

    age.secrets = myLib.getSecrets ./secrets;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        wireguard-tools
        # geekbench_6
        amberol
        rustdesk
        signal-desktop
        obs-studio
        hyprpolkitagent

        protonup-qt
        prismlauncher
        steam
        everest-mons

        ferrishot
        vlc
        kdePackages.kdenlive
        # orca-slicer
        # bambu-studio
        qt6ct
        vesktop
        nautilus
        geeqie
        alsa-scarlett-gui

        xdg-desktop-portal
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}

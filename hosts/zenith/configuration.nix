{ inputs, pkgs, pkgs-stable, system, myLib, ...}:

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

        neovim
        steam
        zsh
    ];

    services.xserver.xkb.layout = "us";

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_16;

    services.flatpak.enable = true;

    boot.plymouth.enable = true;


    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    programs.localsend.enable = true;

    services.lact.enable = true;

    services.openssh.enable = true;

    age.secrets = myLib.getSecrets ./secrets;

    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        gimp
        heroic
        # geekbench_6
        rustdesk
        signal-desktop
        obs-studio
        hyprpolkitagent

        protonup-qt
        pkgs-stable.prismlauncher
        steam
        everest-mons

        ferrishot
        vlc
        kdePackages.kdenlive
        orca-slicer
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

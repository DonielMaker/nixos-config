{ config, lib, pkgs, ... }: 

# Enables settings deemed necessary for running Desktop Devices.

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.desktop;
in

{
    options.modules.desktop.enable = mkEnableOption "Enable Desktop";

    config = mkIf cfg.enable {

        # Enable graphics
        hardware.graphics.enable = true;
        hardware.graphics.enable32Bit = true;

        # Sets a image while booting (Might move into seperate config)
        boot.plymouth.enable = true;

        # Enabled the power-profiles-daemon which allows setting Cpu performance
        # modes (Battery Saver, Balanced, Performance)
        services.power-profiles-daemon.enable = true;

        # Enables info about Batteries
        services.upower.enable = true;

        # Privilege control
        security.polkit.enable = true;

        # File sharing
        programs.localsend.enable = true;

        # Required for Wayland
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        environment.systemPackages = with pkgs; [

            vim # vim

            vlc # Video Viewer
            libreoffice # Office Suite
            librewolf # Firefox based Browser
            brave # Chromium based Browser
            signal-desktop # Messaging Client
            thunderbird # Email Client
            gnupg # Encrypted signing
            kdePackages.gwenview # Image viewer
            kdePackages.kate # Text editor

            xwayland # X11 Interface
            wl-clipboard # Command line copy/paste tool
            cliphist # Clipboard manager

            home-manager # Used by nixos for dotfiles
        ];
    };
}

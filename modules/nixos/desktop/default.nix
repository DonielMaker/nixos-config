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

        # Sets an image while booting
        boot.plymouth.enable = true;

        # Enabled the power-profiles-daemon which allows setting Cpu performance
        # modes (Battery Saver, Balanced, Performance)
        services.power-profiles-daemon.enable = true;

        # Enables info about Battery
        services.upower.enable = true;

        # Privilege control
        security.polkit.enable = true;

        # File sharing
        programs.localsend.enable = true;

        # Overlay VPN
        services.netbird.enable = true;

        # Display Manager
        services.displayManager.ly.enable = true;

        # environment.sessionVariables.NIXOS_OZONE_WL = "1";

        environment.systemPackages = with pkgs; [

            brave # Chromium based Browser
            gnupg # Encrypted signing
            kdePackages.gwenview # Image viewer
            kdePackages.kate # Text editor
            libreoffice # Office Suite
            librewolf # Firefox based Browser
            signal-desktop # Messaging Client
            thunderbird # Email Client
            vlc # Video Viewer

            cliphist # Clipboard manager
            cryptsetup # Drive Encryption
            restic # Backup tool
            vim # vim
            wl-clipboard # Command line copy/paste tool
            xwayland # X11 Interface

            home-manager # Dotfile management
        ];
    };
}

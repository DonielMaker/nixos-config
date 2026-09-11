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

        boot.plymouth.enable = true; # Sets an image while booting

        services.power-profiles-daemon.enable = true; # Allows setting Cpu performance modes (Battery Saver, Balanced, Performance)

        services.upower.enable = true; # Enables info about Battery

        security.polkit.enable = true; # Privilege control

        programs.localsend.enable = true; # File sharing

        services.netbird.enable = true; # Overlay VPN

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

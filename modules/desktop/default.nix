{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.desktop;
in

{
    options.modules.desktop.enable = mkEnableOption "Enable Desktop";

    config = mkIf cfg.enable {

        # File sharing
        programs.localsend.enable = true;

        environment.systemPackages = with pkgs; [

            vim # vim

            vlc # Video Viewer
            libreoffice # Office Suite
            librewolf # Firefox-based Browser
            brave # Chromium-based Browser
            signal-desktop # Messaging
            thunderbird # Email Application
            gnupg # Encrypted signing
            kdePackages.gwenview # Image viewer
            kdePackages.kate # Text editor

            home-manager # Used by nixos for dotfiles
        ];
    };
}

{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.desktop.gnome;
in

{
    options.modules.desktop.gnome.enable = mkEnableOption "Enable Gnome";

    config = mkIf cfg.enable {

        services.desktopManager.gnome.enable = true;
        services.gnome.core-apps.enable = false;

        services.displayManager.gdm.enable = true;
        services.fprintd.enable = false; # Problems with Remote User

        # programs.kdeconnect.enable = true;
        # programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        # Secret Service Provider
        services.gnome.gnome-keyring.enable = true;
        programs.seahorse.enable = true;

        environment.systemPackages = with pkgs; [

            nautilus
            gnome-terminal

            gnomeExtensions.clipboard-history
            gnomeExtensions.caffeine
        ];
    };
}

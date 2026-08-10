{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.desktop.hyprland;
in

{
    options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

    config = mkIf cfg.enable {

        programs.hyprland.enable = true;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        # Secret Service Provider
        services.gnome.gnome-keyring.enable = true;

        services.gvfs.enable = true;

        environment.systemPackages = with pkgs; [

            kitty # For crashes
            nautilus # File explorer
            seahorse # Manage Gnome-Keyring
        ];

        # Allows interoperabilty between Applications
        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

        # This is only for the FileChooser from gtk which hyprland-portal does not have
        xdg.portal.config = {
            common = {
                default = [ "hyprland" ];
                "org.freedesktop.impl.FileChooser" = "gtk";
            };
        };
    };
}

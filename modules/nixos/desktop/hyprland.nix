{ config, lib, pkgs, ... }: 

let
    cfg = config.modules.desktop.hyprland;
in

{
    options.modules.desktop.hyprland = {
        enable = lib.mkEnableOption "Enable Hyprland";
    
        keyboard.layout = lib.mkOption {
            default = "us";
            description = "Keyboard layout in Hyprland";
            type = lib.types.str;
        };

        monitors = lib.mkOption {
            default = "";
            description = "Monitor configuration";
            type = lib.types.str;
            example = ''
                hl.monitor({
                    output = "",
                    mode = "1920x1080@60",
                    position = "auto",
                    scale = 1,
                })
            '';
        };
    };

    config = lib.mkIf cfg.enable {

        programs.hyprland.enable = true;
        services.displayManager.gdm.enable = true;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        security.polkit.enable = true; # Privilege control

        services.gvfs.enable = true;

        services.power-profiles-daemon.enable = true; # Allows setting CPU performance modes

        services.upower.enable = true; # Enables info about Battery

        # Secret Service Provider
        services.gnome.gnome-keyring.enable = true;
        programs.seahorse.enable = true;

        environment.systemPackages = with pkgs; [

            kitty # For crashes
            nautilus # File explorer
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

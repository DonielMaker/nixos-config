{ pkgs, ... }: 

{
    # Window Manager
    programs.hyprland.enable = true;
    security.polkit.enable = true;
    services.hypridle.enable = true;

    environment.sessionVariables = {
        # Activate if Cursor keeps dissappearing
        # WLR_NO_HARDWARE_CURSORS = "1";

        # Required for Wayland
        NIXOS_OZONE_WL = "1";
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
        eww
        swww
        xwayland
        wl-clipboard
        cliphist
    ];
}

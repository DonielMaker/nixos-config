{ pkgs, ... }: 

{
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    security.polkit.enable = true;

    boot.plymouth.enable = true;

    environment.sessionVariables = {
        # Required for Wayland
        NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
        wl-clipboard
        cliphist
    ];
}

{ pkgs, ... }: 

{
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    environment.sessionVariables = {
        # Required for Wayland
        NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
        swww
        xwayland
        wl-clipboard
        cliphist
    ];
}

{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.graphics;
in

{
    options.modules.desktop.graphics.enable = mkEnableOption "Enable Graphics";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        hardware.graphics.enable = true;
        hardware.graphics.enable32Bit = true;

        security.polkit.enable = true;

        boot.plymouth.enable = true;

        environment.sessionVariables = {
            # Activate if Cursor keeps dissappearing
            # WLR_NO_HARDWARE_CURSORS = "1";

            # Required for Wayland
            NIXOS_OZONE_WL = "1";
        };

        environment.systemPackages = with pkgs; [
            xwayland
            wl-clipboard
            cliphist
        ];
    };
}

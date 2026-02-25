{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled assertCollision;
    cfg = config.modules.desktop.plasma;
in

{
    options.modules.desktop.plasma.enable = mkEnableOption "Enable Plasma";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
            (assertCollision cfg config.modules.desktop.hyprland.enable)
        ];

        services.desktopManager.plasma6.enable = true;

        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;

        environment.systemPackages = with pkgs.kdePackages; [
            discover
            kcalc
            kcharselect
            kclock
            kcolorchooser
            kolourpaint
            ksystemlog
            spectacle
            krfb

            pkgs.kdiff3

            isoimagewriter
            partitionmanager

            pkgs.hardinfo2
            pkgs.wayland-utils
        ];
    };
}

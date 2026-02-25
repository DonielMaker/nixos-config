{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled assertCollision;
    cfg = config.modules.desktop.hyprland;
in

{
    options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
            (assertCollision cfg config.modules.desktop.plasma.enable)
        ];

        programs.hyprland.enable = true;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        services.gvfs.enable = true;

        environment.systemPackages = with pkgs; [

            geeqie
            kitty

            nautilus

            hyprpolkitagent
        ];
    };
}

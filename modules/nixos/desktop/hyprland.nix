{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
    cfg = config.modules.desktop.hyprland;
in

{
    options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

    options.modules.desktop.hyprland.monitor = mkOption {
            default = ", prefferred, auto, 1";
            type = types.either types.str (types.listOf types.str);
            description = "Monitor(s) used in Hyprland";
    };

    config = mkIf cfg.enable {

        programs.hyprland.enable = true;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        services.gvfs.enable = true;

        environment.systemPackages = with pkgs; [

            kitty # For crashes

            nautilus # File explorer
        ];
    };
}

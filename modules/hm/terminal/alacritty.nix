{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.alacritty;
in

{
    options.modules.terminal.alacritty.enable = mkEnableOption "Enable Alacritty";

    config = mkIf cfg.enable {
        programs.alacritty.enable = true;
        programs.alacritty.settings = {
            window = {
                decorations = "None";
                padding = { x = 10; y = 10; };
            };
        };
    };
}

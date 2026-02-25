{ config, lib, ... }:

let
    module = "Alacritty";
    cfg = config.modules.hm.alacritty;
in with lib;

{
    options.modules.hm.alacritty.enable = mkEnableOption "Enable ${module}";

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

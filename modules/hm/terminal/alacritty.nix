{ osConfig, lib, ...}:

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.terminal.alacritty.enable {

        programs.alacritty.enable = true;
        programs.alacritty.settings = {
            window = {
                decorations = "None";
                padding = { x = 10; y = 10; };
            };
        };
    };
}

{ osConfig, lib, ...}:

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.terminal.ghostty.enable {

        programs.ghostty.enable = true;
        programs.ghostty = {
            settings = {
                window-padding-x = 10;
                window-padding-y = 10;
            };
        };
    };
}

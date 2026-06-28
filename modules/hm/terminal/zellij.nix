{ osConfig, lib, ...}:

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.terminal.zellij.enable {

        # Config tbi
        programs.zellij.enable = true;
    };
}

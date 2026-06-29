{ osConfig, lib, ... }:

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.programs.vesktop.enable {

        programs.vesktop.enable = true;
        programs.vesktop.vencord.useSystem = true;
    };
}

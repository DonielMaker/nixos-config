{ osConfig, lib, ... }:

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.programs.obsidian.enable {
        programs.obsidian.enable = true;
    };
}

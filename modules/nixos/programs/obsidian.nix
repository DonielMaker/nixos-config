{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.programs.obsidian.enable = mkEnableOption "Enable Obsidian";
}

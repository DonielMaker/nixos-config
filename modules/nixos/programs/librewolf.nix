{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.programs.librewolf.enable = mkEnableOption "Enable Librewolf";
}

{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.desktop.noctalia.enable = mkEnableOption "Enable Noctalia";
}

{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.terminal.git.enable = mkEnableOption "Enable Git";
}

{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.terminal.ghostty.enable = mkEnableOption "Enable Ghostty";
}

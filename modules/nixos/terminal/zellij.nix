{ lib, ... }: 

let
    inherit (lib) mkEnableOption;
in

{
    # Just a passthrough to home-manager
    options.modules.terminal.zellij.enable = mkEnableOption "Enable Zellij";
}

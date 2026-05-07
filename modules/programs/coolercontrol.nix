{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.coolercontrol;
in

{
    options.modules.programs.coolercontrol.enable = mkEnableOption "Enable Steam";

    config = mkIf cfg.enable {

        programs.coolercontrol.enable = true;

        environment.systemPackages = with pkgs.coolercontrol; [ 
            coolercontrold 
            coolercontrol-gui 
            coolercontrol-ui-data 
        ];
    };
}

{ config, lib, pkgs, ... }: 

# This enables the woeusb utility for installing win10/win11 isos through linux
# https://woeusb.org/

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.woeusb;
in

{
    options.modules.programs.woeusb.enable = mkEnableOption "Enable Woeusb";

    config = mkIf cfg.enable {

        boot.supportedFilesystems = [ "ntfs" ];
        environment.systemPackages = with pkgs; [ woeusb ];
    };
}

{ config, lib, sLib, pkgs-stable, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.sound;
in

{
    options.modules.desktop.sound.enable = mkEnableOption "Enable Sound";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        security.rtkit.enable = true;
        services.pipewire.enable = true;
        services.pipewire = {
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            wireplumber.enable = true;
            # If you want to use JACK applications, uncomment this
            #jack.enable = true;
        };

        environment.systemPackages = with pkgs-stable; [
            pavucontrol
            pamixer
        ];
    };
}

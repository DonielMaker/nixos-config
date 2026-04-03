{config, lib, sLib, inputs, ...}: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.dms;
in

{
    options.modules.desktop.dms.enable = mkEnableOption "Enable DankMaterialShell";

    imports = [
        inputs.dms.nixosModules.dank-material-shell 
        inputs.dms.nixosModules.greeter
    ];

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        programs.dank-material-shell.enable = true;
        programs.dank-material-shell = {
            systemd.enable = true;
            systemd.restartIfChanged = true;
            enableDynamicTheming = false;
            enableAudioWavelength = false;
        };

        programs.dank-material-shell.greeter.enable = true;
        programs.dank-material-shell.greeter = {
            compositor.name = "hyprland";
            # Dms-Greeter does not seem to sync up with the main config
            configHome = config.users.users.${config.modules.system.username}.home;
            # configFiles = [
            #   "/home/${config.modules.system.username}/.config/DankMaterialShell/settings.json"
            #   "/home/${config.modules.system.username}/.local/state/DankMaterialShell/session.json"
            # ];
        };
    };
}

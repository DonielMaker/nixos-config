{config, lib, sLib, ...}: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.dms;
in

{
    options.modules.desktop.dms.enable = mkEnableOption "Enable DankMaterialShell";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        programs.dms-shell.enable = true;
        programs.dms-shell = {
            systemd.enable = true;
            systemd.restartIfChanged = true;
            enableDynamicTheming = false;
            enableAudioWavelength = false;
        };

        services.displayManager.dms-greeter.enable = true;
        services.displayManager.dms-greeter = {
            compositor.name = "hyprland";
            # Dms-Greeter does not seem to sync up with the main config
            configHome = config.users.users.${config.modules.system.username}.home;
            configFiles = [
              "/home/${config.modules.system.username}/.config/DankMaterialShell/settings.json"
              "/home/${config.modules.system.username}/.local/state/DankMaterialShell/session.json"
            ];
        };
    };
}

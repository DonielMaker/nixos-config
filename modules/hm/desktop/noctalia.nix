{config, inputs, lib, ...}: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.hm.noctalia;
in

{
    options.modules.hm.noctalia.enable = mkEnableOption "Enable Noctalia Shell";

    imports = [
        inputs.noctalia.homeModules.default
    ];

    config = mkIf cfg.enable {
        programs.noctalia-shell.enable = true;
        programs.noctalia-shell.systemd.enable = true;
        programs.noctalia-shell.settings = {
            settingsVersion = 59;

            general = {
                avatarImage = "/home/donielmaker/webdav/pictures/Matt.jpg";
            };

            location = {
                name = "Bremen";
                autoLocate = false;
            };

            wallpaper = {
                directory = "/home/donielmaker/.config/wallpapers";
            };

            bar = {
                barType = "floating";
                widgets = {
                    left = [
                    {
                        id = "ControlCenter";
                    }
                    {
                        id = "Workspace";
                    }
                    ];

                    center = [
                    {
                        id = "Clock";
                    }
                    ];

                    right = [
                    { id = "Tray"; }
                    { id = "Battery"; }
                    { id = "NotificationHistory"; }
                    {
                        id = "Microphone";
                        middleClickCommand = "pwvucontrol || pavucontrol";
                    }
                    {
                        id = "Volume";
                        middleClickCommand = "pwvucontrol || pavucontrol";
                    }
                    { id = "Network"; }
                    { id = "Bluetooth"; }
                    ];
                };
            };
        };
    };
}

{config, osConfig, inputs, lib, pkgs, ...}: 

let
    inherit (lib) mkIf;
in

{

    imports = [ inputs.noctalia.homeModules.default ];

    config = mkIf osConfig.modules.desktop.noctalia.enable {

        home.packages = with pkgs; [
            curl
            ffmpeg
            gifski
            grim
            imagemagick
            jq
            satty
            slurp
            tesseract
            wl-clipboard
            wl-screenrec
            zbar
        ];

        programs.noctalia-shell.enable = true;
        programs.noctalia-shell.settings = {
            settingsVersion = 59;

            general = {
                radiusRatio = 0.2;
                iRadiusRatio = 0.7;
                avatarImage = "/home/${config.home.username}/.config/wallpapers/Matt.jpg";
            };

            wallpaper.directory = "/home/${config.home.username}/.config/wallpapers";

            idle = {
                enabled = true;
                lockTimeout = 180;
                screenOffTimeout = 300;
                suspendTimeout = 0;
            };

            dock.enabled = false;

            osd.location = "bottom";

            appLauncher = {
                enableClipboardHistory = true;
                showCategories = false;
            };

            # Make sure to download this (Can this be created declaratively?)
            colorSchemes.predefinedScheme = "Tokyo Night Storm";
            templates.activeTemplates = [
                # Create kcolorscheme (Since stylix doesn't?)
                { enabled = true; id = "kcolorscheme"; }
            ];

            bar = {
                barType = "simple";
                # barType = "floating";
                showCapsule = false;

                widgets = {
                    left = [
                        {
                            id = "ControlCenter";
                            useDistroLogo = true;
                            enableColorization = true;
                            colorizeSystemIcon = "primary";
                        }
                        {
                            id = "Workspace";
                            emptyColor = "none";
                            occupiedColor = "none";
                        }
                        {
                            id = "MediaMini";
                            maxWidth = 200;
                        }
                    ];

                    center = [
                        {
                            id = "Clock";
                            formatHorizontal = "MMM dd, HH:mm:ss";
                        }
                    ];

                    right = [
                        { 
                            id = "Tray"; 
                            colorizeIcons = false;
                            pinned = [
                                "Vesktop"
                                "Signal Desktop"
                            ];
                        }
                        { id = "plugin:privacy-indicator"; }
                        {
                            id = "Battery"; 
                            displayMode = "graphic";
                        }
                        { 
                            id = "NotificationHistory"; 
                            iconColor = "secondary";
                            textColor = "secondary";
                        }
                        {
                            id = "KeepAwake";
                            iconColor = "error";
                            textColor = "error";
                        }
                        {
                            id = "Microphone";
                            iconColor = "primary";
                            textColor = "primary";
                            displayMode = "alwaysShow";
                            middleClickCommand = "pavucontrol";
                        }
                        {
                            id = "Volume";
                            iconColor = "tertiary";
                            textColor = "tertiary";
                            displayMode = "alwaysShow";
                            middleClickCommand = "pavucontrol";
                        }
                        { id = "Bluetooth"; }
                        { 
                            id = "Network"; 
                            displayMode = "alwaysHide";
                        }
                    ];
                };
            };
        };
    };
}

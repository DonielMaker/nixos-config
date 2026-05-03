{config, inputs, lib, pkgs, ...}: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.desktop.noctalia;
in

{
    options.modules.desktop.noctalia.enable = mkEnableOption "Enable Noctalia Shell";


    config = mkIf cfg.enable {

        services.power-profiles-daemon.enable = true;

        services.upower.enable = true;

        home-manager.users.${config.modules.system.username} = {

            imports = [ inputs.noctalia.homeModules.default ];

            config = {
                home.packages = with pkgs; [
                    grim
                    slurp
                    zbar
                    satty
                    tesseract
                    jq
                    wl-screenrec
                    gifski
                ];

                programs.noctalia-shell.enable = true;
                programs.noctalia-shell.settings = {
                    settingsVersion = 59;

                    general = {
                        radiusRatio = 0.5;
                        iRadiusRatio = 0.7;
                        # This might be problematic
                        avatarImage = "/home/donielmaker/webdav/pictures/Matt.jpg";
                    };

                    # This might be problematic
                    wallpaper.directory = "/home/donielmaker/.config/wallpapers";

                    location = {
                        name = "Bremen";
                        autoLocate = false;
                    };

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

                    # Does this even work?
                    # plugins = {
                    #     version = 2;
                    #     sources = [
                    #         {
                    #             enabled = true;
                    #             name = "Official Noctalia Plugins";
                    #             url = "https://github.com/noctalia-dev/noctalia-plugins";
                    #         }
                    #     ];
                    #
                    #     states = {
                    #         screen-toolkit = {
                    #             enabled = true;
                    #             sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
                    #         };
                    #     };
                    # };

                    bar = {
                        barType = "floating";
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
                                { id = "Battery"; }
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
                                    displayMode = "never";
                                }
                            ];
                        };
                    };
                };
            };
        };
    };
}

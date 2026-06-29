{ osConfig, ... }:

{

    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.settings = {
        # Fix this?
        workspace = [
            "1, monitor:DP-1"
            "2, monitor:DP-1"
            "3, monitor:DP-1"

            "4, monitor:DP-2"
            "5, monitor:DP-2"
            "6, monitor:DP-2"
            "7, monitor:DP-2"
        ];
    };

    home = {
        inherit (osConfig.modules.system) username;
        homeDirectory = "/home/${osConfig.modules.system.username}";
        stateVersion = "24.11";
    };
}

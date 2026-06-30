{ osConfig, ... }:

{

    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.settings.workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-2"

        "5, monitor:DP-2, default:true, layout:scrolling, layoutopt:direction:down"
        "6, monitor:DP-2, layout:scrolling, layoutopt:direction:down"
        "7, monitor:DP-2, layout:scrolling, layoutopt:direction:down"
        "8, monitor:DP-2, layout:scrolling, layoutopt:direction:down"
    ];

    home = {
        inherit (osConfig.modules.system) username;
        homeDirectory = "/home/${osConfig.modules.system.username}";
        stateVersion = osConfig.system.stateVersion;
    };
}

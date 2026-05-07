{ modules, ... }:

{
    wayland.windowManager.hyprland.settings = {
        # Fix this
        workspace = [
            "1, monitor:DP-1"
            "2, monitor:DP-1"
            "3, monitor:DP-1"

            "4, monitor:DP-2"
            "5, monitor:DP-2"
            "6, monitor:DP-2"
            "7, monitor:DP-2"
            # Do we want this as default?
            # "r[4-10], monitor:DP-2, layout:scrolling, layoutopt:direction:down"
        ];
    };

    home = {
        inherit (modules.system) username;
        homeDirectory = "/home/${modules.system.username}";
        stateVersion = "24.11";
    };
}

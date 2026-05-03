{ modules, ... }:

{
    wayland.windowManager.hyprland.settings = {
        # Fix this
        workspace = [
            "1, monitor:DP-1, default:true"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-2, default:true"
            "5, monitor:DP-2"
        ];
    };

    home = {
        inherit (modules.system) username;
        homeDirectory = "/home/${modules.system.username}";
        stateVersion = "24.11";
    };
}

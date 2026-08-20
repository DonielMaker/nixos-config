{ osConfig, ... }:

{
    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.extraConfig = ''

        hl.monitor({
            output = "DP-1",
            mode = "2560x1440@144",
            position = "auto",
            scale = 1,
        })

        hl.monitor({
            output = "DP-2",
            mode = "1920x1080@180",
            position = "auto-left",
            scale = 1,
            transform = 3,
        })

        hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
        hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
        hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
        hl.workspace_rule({ workspace = "4", monitor = "DP-1" })

        hl.workspace_rule({ workspace = "5", monitor = "DP-2", default = true, layout = "scrolling", layout_opts = { direction = "down" }})
        hl.workspace_rule({ workspace = "6", monitor = "DP-2", layout = "scrolling", layout_opts = { direction = "down" }})
        hl.workspace_rule({ workspace = "7", monitor = "DP-2", layout = "scrolling", layout_opts = { direction = "down" }})
        hl.workspace_rule({ workspace = "8", monitor = "DP-2", layout = "scrolling", layout_opts = { direction = "down" }})
    '';

    home = {
        inherit (osConfig.settings) username;
        homeDirectory = "/home/${osConfig.settings.username}";
        stateVersion = osConfig.system.stateVersion;
    };
}

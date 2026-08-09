{ osConfig, ... }:

{

    home = {
        inherit (osConfig.modules.system) username;
        homeDirectory = "/home/${osConfig.modules.system.username}";
        stateVersion = osConfig.system.stateVersion;
    };

    wayland.windowManager.hyprland.extraConfig = ''

        hl.monitor({
            output = "",
            mode = "1920x1080@60",
            position = "auto",
            scale = 1,
        })
    '';
}

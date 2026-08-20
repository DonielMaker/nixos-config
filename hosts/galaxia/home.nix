{ osConfig, ... }:

{

    wayland.windowManager.hyprland.extraConfig = ''

        hl.monitor({
            output = "",
            mode = "1920x1080@60",
            position = "auto",
            scale = 1,
        })
    '';

    home = {
        inherit (osConfig.settings) username;
        homeDirectory = "/home/${osConfig.settings.username}";
        stateVersion = osConfig.system.stateVersion;
    };
}

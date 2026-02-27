{config, ... }:

{
    modules.hm = {
        mail = "daniel.schmidt0204@gmail.com";
        keyboard.layout = "us";
        
        alacritty.enable = true;
        git.enable = true;
        neovim.enable = true;
        starship.enable = true;
        zellij.enable = true;
        zsh.enable = true;

        stylix.enable = true;
        librewolf.enable = true;
        hyprland.enable = true;
        hyprland.monitor = [
            "DP-1, 2560x1440@144hz, auto, 1"
            "DP-2, 1920x1080@180hz, auto-left, 1, transform, 3"
        ];
    };

    wayland.windowManager.hyprland.settings = {
        # Fix this
        workspace = [
            "1, monitor:DP-1, default:true"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-2, default:true"
            "5, monitor:DP-2, default:true"
        ];
    };

    home = {
        inherit (config.modules.hm) username;
        homeDirectory = "/home/${config.modules.hm.username}";
        stateVersion = "24.11";
    };
}

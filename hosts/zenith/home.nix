{ modules, ... }:

{
    modules = {
        desktop = {
            hyprland.enable = true;
            noctalia.enable = true;
            stylix.enable = true;
        };

        programs = {
            librewolf.enable = true;
            obsidian.enable = true;
            vesktop.enable = true;
        };

        terminal = {
            alacritty.enable = true;
            git.enable = true;
            neovim.enable = true;
            starship.enable = true;
            zellij.enable = true;
            zsh.enable = true;
        };
    };

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
        inherit (modules.system) username;
        homeDirectory = "/home/${modules.system.username}";
        stateVersion = "24.11";
    };
}

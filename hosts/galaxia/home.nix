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

    home = {
        inherit (modules.system) username;
        homeDirectory = "/home/${modules.system.username}";
        stateVersion = "24.11";
    };
}

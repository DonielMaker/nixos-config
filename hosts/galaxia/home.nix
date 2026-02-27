{ config, ... }:

{
    modules.hm = {
        mail = "daniel.schmidt0204@gmail.com";
        
        alacritty.enable = true;
        git.enable = true;
        neovim.enable = true;
        starship.enable = true;
        zellij.enable = true;
        zsh.enable = true;

        stylix.enable = true;
        librewolf.enable = true;
        hyprland.enable = true;
        hyprland.monitor = ", 1920x1080@60hz, auto, 1";
    };

    home = {
        inherit (config.modules.hm) username;
        homeDirectory = "/home/${config.modules.hm.username}";
        stateVersion = "24.11";
        keyboard.layout = "de";
    };
}

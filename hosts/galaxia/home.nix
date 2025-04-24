{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        rofi
        firefox
        oh-my-posh
        zsh
        neovim
        git
        hyprland
        themes
        hypridle
        kitty
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        mangohud
        rofi
        oh-my-posh
        zsh
        neovim
        git
        oh-my-posh
        hyprland
        themes
        zsh
        git
        hypridle
        kitty
        flameshot
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        oh-my-posh
        zsh
        neovim
        git
        hyprland
        themes
        hypridle
        kitty
        flameshot
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.05";
    };
}

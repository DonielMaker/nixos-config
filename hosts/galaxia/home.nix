{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        firefox
        # oh-my-posh
        zellij
        starship
        zsh
        fuzzel
        neovim
        git
        hyprland
        themes
        hypridle
        alacritty
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

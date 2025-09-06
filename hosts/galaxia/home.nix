{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        inputs.stylix.homeModules.stylix

        firefox
        zellij
        starship
        zsh
        fuzzel
        neovim
        git
        hyprland
        stylix
        hypridle
        alacritty
        flameshot
    ];

    home = {
        inherit username;
        homeDirectory = /home/${username};
        stateVersion = "24.11";
    };
}

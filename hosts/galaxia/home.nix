{ inputs, username, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        inputs.stylix.homeModules.stylix

        alacritty
        zellij
        starship
        zsh
        neovim
        git

        fuzzel

        hyprland
        hyprlock
        hypridle
        stylix
    ];

    home = {
        inherit username;
        homeDirectory = /home/${username};
        stateVersion = "25.05";
        keyboard.layout = "de";
    };
}

{ inputs, username, ... }:

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
        stateVersion = "25.05";
        keyboard.layout = "de";
    };
}

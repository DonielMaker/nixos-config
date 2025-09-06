{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        inputs.stylix.homeModules.stylix

        firefox
        # oh-my-posh
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
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

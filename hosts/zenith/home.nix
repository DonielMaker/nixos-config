{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        firefox
        zellij
        mangohud
        starship
        zsh
        fuzzel
        neovim
        git
        hyprland
        themes
        git
        hypridle
        kitty
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

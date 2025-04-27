{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        firefox
        mangohud
        rofi
        # oh-my-posh
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
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

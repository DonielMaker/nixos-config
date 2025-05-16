{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        inputs.walker.homeManagerModules.walker
        fuzzel
        firefox
        mangohud
        starship
        # rofi
        walker
        # oh-my-posh
        zsh
        neovim
        git
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

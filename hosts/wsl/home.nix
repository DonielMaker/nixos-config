{ inputs, username, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        zellij
        starship
        zsh
        neovim
        git
    ];

    home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
    };
}

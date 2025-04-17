{ inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        zsh
        git
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

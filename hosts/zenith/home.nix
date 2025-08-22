{inputs, username, lib, ... }:

{
    imports = with inputs.self.homeManagerModules; [
        inputs.stylix.homeModules.stylix

        stylix
        firefox
        zellij
        mangohud
        starship
        zsh
        fuzzel
        neovim
        git
        hyprland
        git
        hypridle
        # kitty
        alacritty
    ];

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };

    wayland.windowManager.hyprland.settings = {
        workspace = [
            "1, monitor:DP-1, default:true"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-2, default:true"
        ];
    };
}

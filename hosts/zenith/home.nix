{inputs, username, ... }:

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
        hyprland
        git
        hypridle
        alacritty
        flameshot
    ];

    wayland.windowManager.hyprland.settings = {
        workspace = [
            "1, monitor:DP-1, default:true"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-2, default:true"
            "5, monitor:DP-2, default:true"
        ];
    };

    home = {
        inherit username;
        homeDirectory = /home/${username};
        stateVersion = "24.11";
    };
}

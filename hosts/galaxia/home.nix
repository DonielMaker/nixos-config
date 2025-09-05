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
    ];

    # FIX: there's still a problem with the duplication between nixos and hm!!!

    # This is configurable via: networking.hostName = hostname;
    #     hostname = "galaxia";

    # FIX: This technically already is configured ???
    #     system = "x86_64-linux";

    # This is a lot harder as it would mean moving the entire users.users.<name>
    # config to the specific hosts
    #     username = "donielmaker";

    # programs.git.userEmail
    #     mail = "daniel.schmidt0204@gmail.com";

    # This should be done via $XDG_CONFIG_HOME
    #     dotfiles = "/home/${username}/.config";

    # Both are hyprland configs
    # WARN: kb_layout is required by both nixos and hm
    #     kb_layout = "de";
    #     monitor = ", 1920x1080@60hz, auto, 1";

    # time.timeZone
    #     timezone = "Europe/Berlin";

    # users.users.<name>.shell
    #     shell = "zsh";

    home = {
        inherit username;
        homeDirectory = lib.mkForce "/home/${username}";
        stateVersion = "24.11";
    };
}

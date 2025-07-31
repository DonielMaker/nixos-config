{
    programs.alacritty.enable = true;
    programs.alacritty.theme = "catppuccin_macchiato";
    programs.alacritty.settings = {
        window = {
            decorations = "None";
            padding = { x = 10; y = 10; };
        };

        font.normal.family = "FiraCode Nerd Font";
        font.size = 12;
    };
}

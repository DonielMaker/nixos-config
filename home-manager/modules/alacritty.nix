{
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
        colors.primary = {
                background = "#24283b";
                foreground = "#a9b1d6";
            };

        colors.normal = {
            black   = "#32344a";
            red     = "#f7768e";
            green   = "#9ece6a";
            yellow  = "#e0af68";
            blue    = "#7aa2f7";
            magenta = "#ad8ee6";
            cyan    = "#449dab";
            white   = "#9699a8";
        };

        colors.bright = {
            black   = "#444b6a";
            red     = "#ff7a93";
            green   = "#b9f27c";
            yellow  = "#ff9e64";
            blue    = "#7da6ff";
            magenta = "#bb9af7";
            cyan    = "#0db9d7";
            white   = "#acb0d0";
        };

        window = {
            opacity = 0.8;
            blur = true;
            decorations = "None";
            padding = { x = 10; y = 10; };
        };

        font.normal.family = "FiraCode Nerd Font";
        font.size = 12;
    };
}

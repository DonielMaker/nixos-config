{...}:

{
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
        colors = {
            background = "24273aff";
            text = "cad3f5ff";
            input = "a5adcbff";
            border = "5b6078dd";
            selection = "8aadf4ff";
            selection-text = "4c4f69ff";
            match = "ed8796ff";
            prompt = "cad3f5ff";
        };
        main = {
            width = 45;
            lines = 20;
            tabs = 4;
            icon-theme = "Tela-Circle-Dark";
            image-size-ratio = 1;
            horizontal-pad = 16;
            fields = "name";
            font = "Dejavu Sans:size=12";
        };
        # dmenu.mode = "text";
        border.width = 2;
    };
}

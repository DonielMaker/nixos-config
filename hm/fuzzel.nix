{lib, ...}:

{
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
        main = {
            width = 45;
            lines = 20;
            tabs = 4;
            image-size-ratio = 1;
            horizontal-pad = 16;
            fields = "name";
            placeholder = "Search...";
            font = lib.mkForce "Dejavu Sans:size=12";
        };
        border.width = 2;
    };
}

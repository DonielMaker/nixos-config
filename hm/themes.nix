{ pkgs, ... }: 

let
    variant = "macchiato";
in

{
    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };

    gtk = {
        enable = true;

        cursorTheme.name = "Bibata-Modern-Ice";
        cursorTheme.package = pkgs.bibata-cursors;

        iconTheme.name = "Papirus";
        iconTheme.package = pkgs.catppuccin-papirus-folders.override {flavor = variant;};

        theme.name = "catppuccin-macchiato-blue-standard";
        theme.package = pkgs.catppuccin-gtk.override {inherit variant;};
    };
} 

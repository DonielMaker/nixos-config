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

        # iconTheme.package = pkgs.catppuccin-papirus-folders.override {flavor = variant;};
        iconTheme.package = pkgs.papirus-icon-theme;

        theme.name = "catppuccin-macchiato-blue-standard";
        theme.package = pkgs.catppuccin-gtk.override {inherit variant;};
    };
} 

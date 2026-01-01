{pkgs, ...}: 

{
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    stylix.polarity = "dark";

    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.size = 24;

    stylix.icons.enable = true;
    stylix.icons.light = "Papirus";
    stylix.icons.dark = "Papirus-Dark";
    stylix.icons.package = pkgs.papirus-icon-theme;

    stylix.targets.plymouth.logoAnimated = false;

    stylix.targets.limine.image.enable = false;
}

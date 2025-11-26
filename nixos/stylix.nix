{pkgs, ...}: 

{
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    stylix.polarity = "dark";

    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.size = 24;

    stylix.targets.plymouth.logoAnimated = false;

    stylix.targets.limine.enable = false;
}

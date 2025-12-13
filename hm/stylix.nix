{pkgs, ...}: 

{

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.size = 24;

    stylix.polarity = "dark";

    stylix.icons.enable = true;
    stylix.icons.light = "Papirus";
    stylix.icons.dark = "Papirus-Dark";
    stylix.icons.package = pkgs.papirus-icon-theme;

    stylix.targets.hyprland.enable = false;
    stylix.targets.neovim.enable = false;
}

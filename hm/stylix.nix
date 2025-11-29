{pkgs, username, ...}: 

{

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.size = 24;

    stylix.polarity = "dark";

    stylix.icons.enable = true;
    stylix.icons.light = "Tela-circle-light";
    stylix.icons.dark = "Tela-circle-dark";
    stylix.icons.package = pkgs.tela-circle-icon-theme;

    stylix.targets.hyprland.enable = false;
    # stylix.targets.alacritty.enable = false;
    stylix.targets.neovim.enable = false;
    # stylix.targets.fuzzel.enable = false;

    stylix.targets.firefox.profileNames = [ username ];
}

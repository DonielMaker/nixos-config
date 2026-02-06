{image,  ...}: 

{
    programs.regreet.enable = true;
    programs.regreet.cageArgs = [ "-s" "-mlast" ];
    programs.regreet.settings = {

        background.path = "${image.login}";
        background.fit = "Cover";

        GTK.cursor_theme_name = "Bibata-Modern-Ice";
        GTK.icon_theme_name = "Papirus-Dark";

        appearance.greeting_msg = "Fuck off";

        widget.clock.format = "%H:%M";
        widget.clock.timezone = "Europe/Berlin";
    };
}

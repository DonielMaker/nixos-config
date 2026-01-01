{lib, image, ...}: 

{
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
        hide_cursor = true;
        ignore_empty_input = true;
        general = {
            grace = 0;
        };

        background = {
            path = "screenshot";
            blur_passes = 3;
            color = lib.mkForce "rgba(36, 40, 59, 1)";
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
        };
        
        input-field = {
            outline_thickness = 2;
            fade_on_empty = false;
            outer_color = lib.mkForce "rgba(47, 51, 76, 1)";
            inner_color = lib.mkForce "rgba(36, 40, 59, 0.7)";
            rounding = 20;
            placeholder_text = "no";
            fail_text = "Contacting Administrator";
            position = "0, -100";
        };

        image = {
            path = "${image.pfp}";
            border_size = "2";
            border_color = "rgba(255, 255, 255, 0)";
            size = "160";
            rounding = "-1";
            rotate = "0";
            reload_time = "-1";
            position = "0, 100";
            halign = "center";
            valign = "center";
        };

        label = {
            text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
            color = "rgba(216, 222, 233, 0.90)";
            font_size = 80;
            font_family = "SF Pro Display Bold";
            position = "0, -100";
            halign = "center";
            valign = "top";
        };
    };
}

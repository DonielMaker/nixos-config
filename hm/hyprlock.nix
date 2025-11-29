{lib, ...}: 

{
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
        hide_cursor = true;
        ignore_empty_input = true;
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
        };
    };
}

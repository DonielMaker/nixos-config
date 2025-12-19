{
    services.hypridle.enable = true;
    services.hypridle.settings = {
        general = {
            lock_cmd = "hyprlock";
            unlock_cmd = "pkill -USR1 hyprlock";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
        };

        listener = [
            {
                timeout = 300;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
            }

            {
                timeout = 310;
                on-timeout = "hyprlock";
            }
        ];
    };
}

{
    services.hypridle.enable = true;
    services.hypridle.settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
        };

        listener = [
            {
                timeout = 300;
                on-timeout = "loginctl lock-session";
            }

            {
                timeout = 600;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
            }

            # {
            #     timeout = 600;
            #     on-timeout = "systemctl suspend";
            # }
        ];
    };
}

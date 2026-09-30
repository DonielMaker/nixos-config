{osConfig, inputs, lib, pkgs, ...}: 

let
    inherit (lib) mkIf;
in

{

    imports = [ inputs.noctalia.homeModules.default ];

    config = mkIf osConfig.modules.desktop.noctalia.enable {

        home.packages = with pkgs; [
            bc # Calculator
            brightnessctl
            curl
            ddcutil # External Monitor Control
        ];

        programs.noctalia.enable = true;
        programs.noctalia.settings = {

            theme = {
                custom_palette = "stylix";
                mode = "dark";
                source = "custom";
                
                templates.builtin_ids = [ "kcolorscheme" ];
            };

            # General Settings
            shell = {
                # avatar_path = "/home/donielmaker/.config/wallpaper/Matt.png";
                corner_radius_scale = 0.4;
                polkit_agent = true;

                launcher = {
                    categories = false;
                    compact = true;
                };

                panel = {
                    control_center_placement = "floating";
                    session_placement = "floating";
                };

                clipboard_auto_paste = "off";

                screenshot = {
                    annotate = true;
                    confirm_region = true;
                    skip_annotate_on_copy_save = true;
                };
            };

            bar.widgets = {
                start = [ "session" "workspaces" "media" ];
                center = [ "clock" ];
                end = [ "tray" "battery" "notifications" "caffeine" "input_volume" "output_volume" "bluetooth" "network" ];

                widget_spacing = 10; # Spacing between Widgets
                margin_ends = 0; # Spacing between Bar and Monitor Edge
                radius = 0; # Radius of Bar

                font_family = "CommitMono Nerd Font";
            };

            widget = {
                caffeine.color = "#f7768e"; # Red
                input_volume.color = "#7aa2f7"; # Blue
                output_volume.color = "#73daca"; # Teal
                notifications.color = "#bb9af7"; # Purple
                session.color = "#f7768e"; # Red

                session.scale = 1.2;

                network.show_label = false; # Don't show the interface name

                clock.format = "{:%a %d, %H:%M:%S}"; # I.E Sun 09, 23:25:03

                workspaces.style = "minimal";
            };

            idle = {
                behavior_order = [ "screen-off" "lock" ];

                behavior.screen-off = {
                    action = "screen-off";
                    enabled = true;
                    timeout = 300.0;
                };

                behavior.lock = {
                    action = "lock";
                    enabled = true;
                    timeout = 600.0;
                };
            };

            osd = {
                position = "bottom_center";
                kinds.media = false; # No OSD on Media Play
            };

            notification.history_retention_hours = 24;

            control_center.shortcuts = []; # No Shortcuts

            audio.enable_overdrive = true; # Max Volume is 150%

            location.auto_locate = true;

            # Disable shitty features
            desktop_widgets.enabled = false;
            dock.enabled = false;
            lockscreen.fingerprint = false;
        };
    };
}

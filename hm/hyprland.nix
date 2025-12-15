{ pkgs, username, monitor, lib, config, ... }:

let
    alacritty = lib.getExe pkgs.alacritty;
    brave = "${lib.getExe pkgs.brave} --ozone-platform=wayland --disable-features=WaylandWpColorManagerV1";
    nautilus = lib.getExe pkgs.nautilus;
    fuzzel = lib.getExe pkgs.fuzzel;
    cliphist = lib.getExe pkgs.cliphist;
    hyprshot = lib.getExe pkgs.hyprshot;
    # hyprpicker = lib.getExe pkgs.hyprpicker;
in

{

    # Allows interoperabilty between Applications
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    xdg.portal.config = {
        common = {
            default = [ "hyprland" ];
            "org.freedesktop.impl.FileChooser" = "gtk";
        };
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland = {
        xwayland.enable = true;

        settings = {
            "$mainMod" = "SUPER";

            inherit monitor;

            env = [
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "QT_QPA_PLATFORM,wayland"
                "QT_QPA_PLATFORMTHEME,qt5ct"
                "XDG_SCREENSHOTS_DIR,~/screenshots"
            ];

            windowrulev2 = [
                # Float Pip in the bottom right
                "float, pin, noinitialfocus, title:^(Picture in picture)"
                # Width, Height
                "size 40% 40%, title:^(Picture in picture)"
                "move 59% 58%, title:^(Picture in picture)"

                # Float Brave Extensions in the bottom left
                "float, pin, class:^(brave-[a-z]+-Default)$"
                "size 30% 50%, class:^(brave-[a-z]+-Default)$"
                "move 1% 48%, class:^(brave-[a-z]+-Default)$"

                # Float gtk portal (File Chooser) in the middle
                "float, center, class:^(xdg-desktop-portal-gtk)$"
                "size 40% 40%, class:^(xdg-desktop-portal-gtk)$"
            ];

            exec-once = [
                "swww-daemon"
                "hypridle"
                # "hyprctl setcursor Bibata-Modern-Ice 24"
                "qs"
                "wl-paste --type text --watch cliphist store"
                "wl-paste --type image --watch cliphist store"
                "systemctl --user start hyprpolkitagent.service"
            ];

            cursor = {
                no_hardware_cursors = true;
            };

            debug = {
                disable_logs = false;
                enable_stdout_logs = true;
            };

            input = {
                kb_layout = config.home.keyboard.layout;

                follow_mouse = 1;

                touchpad = {
                    natural_scroll = true;
                    scroll_factor = 0.25;
                };

                sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            };

            dwindle = {
                preserve_split = true; # you probably want this
            };

            general = {
                gaps_in = 5;
                gaps_out = "20, 20, 20, 20";
                border_size = 3;
                # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                # "col.inactive_border" = "rgba(595959aa)";
                "col.active_border" = "rgba(7dcfffee)";
                "col.inactive_border" = "rgba(2F334Caa)";

                layout = "dwindle";

                # no_cursor_warps = false;
            };

            decoration = {
                rounding = 10;

                dim_inactive = false;

                blur = {
                    enabled = true;
                    size = 16;
                    passes = 2;
                    new_optimizations = true;
                };

                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };
            };


            animations = {
                enabled = true;

                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                # bezier = "myBezier, 0.33, 0.82, 0.9, -0.08";

                animation = [
                    "windows,     1, 7,  myBezier"
                    "windowsOut,  1, 7,  default, popin 80%"
                    "border,      1, 10, default"
                    "borderangle, 1, 8,  default"
                    "fade,        1, 7,  default"
                    "workspaces,  1, 6,  default"
                ];
            };

            misc = {
                animate_manual_resizes = true;
                animate_mouse_windowdragging = true;
                enable_swallow = true;
                # render_ahead_of_time = false;
                disable_hyprland_logo = true;
            };

            bind = [
                # Terminal
                "$mainMod, Return, exec, ${alacritty}"
                # File Explorer
                "$mainMod, E, exec, ${nautilus}"
                # Browser
                "$mainMod, B, exec, ${brave}"
                # Application Launcher
                "$mainMod, space, exec, ${fuzzel}"
                # Clipboard History
                "$mainMod, V, exec, ${cliphist} list | ${fuzzel} --dmenu | ${cliphist} decode | wl-copy"
                "$mainMod CTRL, V, exec, ${cliphist} wipe"
                # Screenshot to Clipboard
                "$mainMod, S, exec, ${hyprshot} -szm region --clipboard-only"
                # Screenshot to file
                "$mainMod SHIFT, S, exec, ${hyprshot} -szm region -o ${config.home.homeDirectory}/Pictures/Screenshots"

                "$mainMod, Q, killactive,"
                "$mainMod, M, exit,"
                "$mainMod, F, togglefloating,"
                "$mainMod, P, pin,"
                "$mainMod, G, fullscreenstate, 2 0"
                "$mainMod, N, exec, hyprlock"

                # Move focus with mainMod + arrow keys
                "$mainMod, h,  movefocus, l"
                "$mainMod, j,  movefocus, d"
                "$mainMod, k,    movefocus, u"
                "$mainMod, l, movefocus, r"

                # Moving windows
                "$mainMod SHIFT, h,  swapwindow, l"
                "$mainMod SHIFT, j,  swapwindow, d"
                "$mainMod SHIFT, k,    swapwindow, u"
                "$mainMod SHIFT, l, swapwindow, r"

                # Window resizing                     X  Y
                "$mainMod CTRL, h,  resizeactive, -60 0"
                "$mainMod CTRL, j,  resizeactive,  0  60"
                "$mainMod CTRL, k,    resizeactive,  0 -60"
                "$mainMod CTRL, l, resizeactive,  60 0"

                # Switch workspaces with mainMod + [0-9]
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
                "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
                "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
                "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
                "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
                "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
                "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
                "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
                "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
                "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

                # Mute source
                "$mainMod, Control_R, exec, pamixer --default-source -t"

                #  INFO: Currently unused

                # Keyboard backlight
                # "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
                # "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"

                # Brightness control
                ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
                ", XF86MonBrightnessUp, exec, brightnessctl set +5% "

                # Laptop related
                ", XF86AudioMute, exec, pamixer -t"
                ", XF86AudioMicMute, exec, pamixer --default-source -t"

                ", XF86AudioRaiseVolume, exec, pamixer -i 5"
                ", XF86AudioLowerVolume, exec, pamixer -d 5"
                "SHIFT, XF86AudioRaiseVolume, exec, pamixer --default-source -i 5"
                "SHIFT, XF86AudioLowerVolume, exec, pamixer --default-source -d 5"
            ];

            bindm = [
                # Interact with Floating Windows
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ];
        };
    };
}

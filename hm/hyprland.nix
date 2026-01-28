{ pkgs, monitor, lib, config, ... }:

let
    terminal = lib.getExe pkgs.alacritty;
    browser = "${lib.getExe pkgs.brave} --ozone-platform=wayland --disable-features=WaylandWpColorManagerV1";
    explorer = lib.getExe pkgs.nautilus;
    launcher = lib.getExe pkgs.fuzzel;
    cliphist = lib.getExe pkgs.cliphist;
    screenshot = lib.getExe pkgs.hyprshot;
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

            windowrule = [
                # Float Pip in the bottom right
                # "float, pin, noinitialfocus, title:^([Pp]icture[ -]in[ -][Pp]icture)"
                "match:title ^([Pp]icture[ -]in[ -][Pp]icture)$, float on, pin on"
                # Width, Height
                "match:title ^([Pp]icture[ -]in[ -][Pp]icture)$, size monitor_w*0.4 monitor_h*0.4"
                "match:title ^([Pp]icture[ -]in[ -][Pp]icture)$, move monitor_w*0.59 monitor_h*0.58"

                # Float Brave Extensions in the bottom left
                "match:class ^(brave-[a-z]+-Default)$, float on, pin on"
                "match:class ^(brave-[a-z]+-Default)$, size monitor_w*0.3 monitor_h*0.5"
                "match:class ^(brave-[a-z]+-Default)$, move monitor_w*0.01 monitor_h*0.48"

                # Float gtk portal (File Chooser) in the middle
                "match:class ^(xdg-desktop-portal-gtk)$, float on, center on"
                "match:class ^(xdg-desktop-portal-gtk)$, size monitor_w*0.4 monitor_h*0.4"
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
                "$mainMod, Return, exec, ${terminal}"
                # File Explorer
                "$mainMod, E, exec, ${explorer}"
                # Browser
                "$mainMod, B, exec, ${browser}"
                # Application Launcher
                "$mainMod, space, exec, ${launcher}"
                # Clipboard History
                "$mainMod, V, exec, ${cliphist} list | ${launcher} --dmenu | ${cliphist} decode | wl-copy"
                "$mainMod CTRL, V, exec, ${cliphist} wipe"
                # Screenshot to Clipboard
                "$mainMod, S, exec, ${screenshot} -szm region --clipboard-only"
                # Screenshot to file
                "$mainMod SHIFT, S, exec, ${screenshot} -szm region -o ${config.home.homeDirectory}/Pictures/Screenshots"

                "$mainMod, Q, killactive,"
                "$mainMod SHIFT, M, exit,"
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

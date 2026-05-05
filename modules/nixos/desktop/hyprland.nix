{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
    cfg = config.modules.desktop.hyprland;
in

{
    options.modules.desktop.hyprland.enable = mkEnableOption "Enable Hyprland";

    options.modules.desktop.hyprland.monitor = mkOption {
            default = ", prefferred, auto, 1";
            type = types.either types.str (types.listOf types.str);
            description = "Monitor used in Hyprland";
    };

    config = mkIf cfg.enable {

        programs.hyprland.enable = true;

        programs.nautilus-open-any-terminal.enable = true;
        programs.nautilus-open-any-terminal.terminal = "alacritty";

        services.gvfs.enable = true;

        environment.systemPackages = with pkgs; [

            kitty # For crashes

            nautilus # File explorer
        ];

        home-manager.users.${config.modules.system.username} = mkIf cfg.enable ({ modules, ... }:

        let
            terminal = lib.getExe pkgs.alacritty;
            browser = "${lib.getExe pkgs.brave} --ozone-platform=wayland --disable-features=WaylandWpColorManagerV1";
            explorer = lib.getExe pkgs.nautilus;

            ipc = "noctalia-shell ipc call";
            launcher = "${ipc} launcher toggle";
            # clipboard = "${ipc} launcher clipboard";
            clipboard = "${ipc} plugin:clipper toggle";
            screenshot-menu = "${ipc} plugin:screen-toolkit toggle";
            screenshot = "${ipc} plugin:screen-toolkit annotate";

            lock = "${ipc} lockScreen lock";
            micMute = "${ipc} volume muteInput";
            audioMute = "${ipc} volume muteOutput";
        in

        {
            # Allows interoperabilty between Applications
            xdg.portal.enable = true;
            xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

            # This is only for the FileChooser from gtk which hyprland-portal does not have
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

                    exec-once = [
                        "wl-paste --type text --watch cliphist store"
                        "wl-paste --type image --watch cliphist store"
                        "noctalia-shell"
                    ];

                    env = [
                        "XDG_CURRENT_DESKTOP,Hyprland"
                        "XDG_SESSION_TYPE,wayland"
                        "XDG_SESSION_DESKTOP,Hyprland"
                        "QT_QPA_PLATFORM,wayland"
                        "QT_QPA_PLATFORMTHEME,qt6ct"
                    ];

                    windowrule = [
                        # Float Pip (Picture in Picture) in the bottom right
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

                    inherit (modules.hypr) monitor;

                    ecosystem.no_update_news = true;

                    cursor.no_hardware_cursors = true;

                    debug = {
                        disable_logs = false;
                        enable_stdout_logs = true;
                    };

                    input = {
                        kb_layout = modules.system.keyboard.layout;

                        follow_mouse = 1;

                        touchpad = {
                            natural_scroll = true;
                            scroll_factor = 0.25;
                        };

                        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                    };

                    dwindle.preserve_split = true; # you probably want this

                    general = {
                        # Gaps between windows
                        gaps_in = 5;
                        # Gaps on top, right, bottom, left
                        gaps_out = "10, 10, 10, 10";
                        # No border
                        border_size = 0;

                        layout = "dwindle";
                    };

                    decoration = {
                        rounding = 10;

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
                        "$mainMod, Return, exec, ${terminal}"
                        "$mainMod, E, exec, ${explorer}"
                        "$mainMod, B, exec, ${browser}"
                        "$mainMod, space, exec, ${launcher}"
                        "$mainMod, N, exec, ${lock}"

                        # Clipboard
                        "$mainMod, V, exec, ${clipboard}"

                        # Screenshot
                        "$mainMod, S, exec, ${screenshot-menu}" 
                        "$mainMod SHIFT, S, exec, ${screenshot}" 

                        # Close current application
                        "$mainMod, Q, killactive,"
                        # Exit Hyprland
                        "$mainMod SHIFT, M, exit,"

                        "$mainMod, F, togglefloating,"
                        "$mainMod, P, pin,"
                        "$mainMod, G, fullscreenstate, 2 0"

                        # Move focus with mainMod + arrow keys
                        "$mainMod, h, movefocus, l"
                        "$mainMod, j, movefocus, d"
                        "$mainMod, k, movefocus, u"
                        "$mainMod, l, movefocus, r"

                        # Moving windows
                        "$mainMod SHIFT, h, swapwindow, l"
                        "$mainMod SHIFT, j, swapwindow, d"
                        "$mainMod SHIFT, k, swapwindow, u"
                        "$mainMod SHIFT, l, swapwindow, r"

                        # Window resizing                     X  Y
                        "$mainMod CTRL, h, resizeactive, -60 0"
                        "$mainMod CTRL, j, resizeactive,  0  60"
                        "$mainMod CTRL, k, resizeactive,  0 -60"
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

                        # Mute Audio/Mic
                        "$mainMod, Control_R, exec, ${micMute}"
                        "$mainMod SHIFT, Control_R, exec, ${audioMute}"

                        # Laptop related (Broken as of now)
                        ", XF86AudioMicMute, exec, ${micMute}"
                        ", XF86AudioMute, exec, ${audioMute}"

                        # Brightness control
                        #", XF86MonBrightnessDown, exec, "
                        #", XF86MonBrightnessUp, exec, "

                        #", XF86AudioRaiseVolume, exec, dms ipc call audio increment 5"
                        #", XF86AudioLowerVolume, exec, dms ipc call audio decrement 5"
                        #"SHIFT, XF86AudioRaiseVolume, exec, pamixer --default-source -i 5"
                        #"SHIFT, XF86AudioLowerVolume, exec, pamixer --default-source -d 5"
                            ];

                    bindm = [
                        # Super + M1
                        "$mainMod, mouse:272, movewindow"
                        # Super + M2
                        "$mainMod, mouse:273, resizewindow"
                    ];
                };
            };
        });
    };
}

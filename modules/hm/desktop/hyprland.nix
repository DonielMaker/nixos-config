{ osConfig, lib, pkgs, ... }: 

let
    inherit (lib) mkIf;
in

{
    config =  mkIf osConfig.modules.desktop.hyprland.enable {

        wayland.windowManager.hyprland.enable = true;
        wayland.windowManager.hyprland.configType = "lua";
        wayland.windowManager.hyprland.extraConfig = let

            terminal = lib.getExe pkgs.alacritty;
            browser = "${lib.getExe pkgs.brave} --ozone-platform=wayland --disable-features=WaylandWpColorManagerV1";
            explorer = lib.getExe pkgs.nautilus;

            # Noctalia related
            ipc = "noctalia msg";
            launcher = "${ipc} panel-open launcher";
            clipboard = "${ipc} panel-open clipboard";
            clipboard-wipe = "cliphist wipe";
            screenshot-menu = "${ipc} plugin alexander/screen-toolkit:service all toggle";
            screenshot = "${ipc} plugin alexander/screen-toolkit:service all annotate";

            lock = "${ipc} session lock";

            micMute = "${ipc} mic-mute";
            audioMute = "${ipc} volume-mute";

            micIncrease = "${ipc} mic-volume-up 5";
            micDecrease = "${ipc} mic-volume-down 5";

            audioIncrease = "${ipc} volume-up 5";
            audioDecrease = "${ipc} volume-down 5";

            mediaPlayPause = "${ipc} media toggle";
            mediaPrev = "${ipc} media previous";
            mediaNext = "${ipc} media next";

        in 

        ''
            -- === Startups ===
            hl.on("hyprland.start", function ()
                hl.exec_cmd("wl-paste --type text --watch cliphist store")
                hl.exec_cmd("wl-paste --type image --watch cliphist store")
                hl.exec_cmd("noctalia")
            end)

            -- === Window Rules ===
            hl.window_rule({
                name = "Float Picture in Picture in the bottom right",
                match = { title = "^([Pp]icture[ -]in[ -][Pp]icture)$"},
                float = true,
                pin = true,
                size = {"monitor_w * 0.4", "monitor_h * 0.4"},
                move = {"monitor_w * 0.59", "monitor_h * 0.58"},
            })

            hl.window_rule({
                name = "Float Brave Extensions in the bottom left",
                match = { class = "^(brave-[a-z]+-Default)$"},
                float = true,
                pin = true,
                size = {"monitor_w * 0.3", "monitor_h * 0.5"},
                move = {"monitor_w * 0.01", "monitor_h * 0.48"},
            })

            hl.window_rule({
                name = "Float gtk portal (File Chooser) in the middle",
                match = { class = "^(xdg-desktop-portal-gtk)$"},
                float = true,
                center = true,
                size = {"monitor_w * 0.4", "monitor_h * 0.4"},
            })

            hl.window_rule({
                name = "Float Satty in the middle",
                match = { class = "^(com.gabm.satty)$"},
                float = true,
                center = true,
                size = {"monitor_w * 0.4", "monitor_h * 0.4"},
            })

            hl.window_rule({
                name = "Float XDG-Desktop-Portal in the middle",
                match = { title = "^(Select what to share)$"},
                float = true,
                center = true,
                size = {"monitor_w * 0.4", "monitor_h * 0.4"},
            })

            -- === General ===
            hl.config({

                ecosystem = {
                    no_donation_nag = true,
                    no_update_news = true,
                },

                cursor = {
                    no_hardware_cursors = 1,
                },

                input = {
                    kb_layout = "${osConfig.services.xserver.xkb.layout}",

                    -- Keyboard repeats faster and quicker
                    repeat_rate = 40,
                    repeat_delay = 300,

                    -- Window focus follows Mouse
                    follow_mouse = 1,

                    touchpad = {
                        natural_scroll = true,
                        scroll_factor = 0.25,
                    },
                },

                scrolling = {
                    column_width = 1,
                },

                dwindle = {
                    preserve_split = true, -- you probably want this
                },

                general = {
                    -- Gaps between windows
                    gaps_in = 0,

                    -- Gaps on top, right, bottom, left
                    gaps_out = 10,

                    -- No border
                    border_size = 0,

                    layout = "dwindle",
                },

                decoration = {
                    rounding = 2,

                    shadow = {
                        enabled = true,
                        range = 4,
                        render_power = 3,
                        color = "rgba(1a1a1aee)",
                    },
                },

                misc = {
                    animate_manual_resizes = true,
                    animate_mouse_windowdragging = true,
                    enable_swallow = true,
                    disable_hyprland_logo = true,
                },
            })

            -- === Animations ===
            hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

            hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
            hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
            hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
            hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
            hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
            hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

            -- === Binds ===
            -- General
            hl.bind("SUPER + Return", hl.dsp.exec_cmd("${terminal}"))
            hl.bind("SUPER + E", hl.dsp.exec_cmd("${explorer}"))
            hl.bind("SUPER + B", hl.dsp.exec_cmd("${browser}"))
            hl.bind("SUPER + space", hl.dsp.exec_cmd("${launcher}"))
            hl.bind("SUPER + N", hl.dsp.exec_cmd("${lock}"))

            -- Clipboard
            hl.bind("SUPER + V", hl.dsp.exec_cmd("${clipboard}"))
            hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("${clipboard-wipe}"))

            -- Screenshot
            hl.bind("SUPER + S", hl.dsp.exec_cmd("${screenshot-menu}"))
            hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("${screenshot}"))

            -- Close current application
            hl.bind("SUPER + Q", hl.dsp.window.close())

            -- Exit Hyprland
            hl.bind("SUPER + SHIFT + M", hl.dsp.exit())

            hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" })) -- Float window
            hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" })) -- Pin window
            hl.bind("SUPER + G", hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" })) -- Fullscreen window without telling the application

            -- Move focus with SUPER + hjkl
            hl.bind("SUPER + h", hl.dsp.focus({ direction = "l"}))
            hl.bind("SUPER + j", hl.dsp.focus({ direction = "d"}))
            hl.bind("SUPER + k", hl.dsp.focus({ direction = "u"}))
            hl.bind("SUPER + l", hl.dsp.focus({ direction = "r"}))

            -- Move windows with SUPER + hjkl
            hl.bind("SUPER + SHIFT + h", hl.dsp.window.swap({ direction = "l"}))
            hl.bind("SUPER + SHIFT + j", hl.dsp.window.swap({ direction = "d"}))
            hl.bind("SUPER + SHIFT + k", hl.dsp.window.swap({ direction = "u"}))
            hl.bind("SUPER + SHIFT + l", hl.dsp.window.swap({ direction = "r"}))

            -- Switch workspaces with SUPER + [0-9]
            hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
            hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
            hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
            hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
            hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
            hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
            hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
            hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
            hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
            hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

            -- Move active window to a workspace with SUPER + SHIFT + [0-9]
            hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
            hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
            hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
            hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
            hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
            hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
            hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
            hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
            hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
            hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

            -- Mute audio/mic
            hl.bind("SUPER + Control_R", hl.dsp.exec_cmd("${micMute}"))
            hl.bind("SUPER + SHIFT + Control_R", hl.dsp.exec_cmd("${audioMute}"))

            hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${audioMute}"))
            hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${micMute}"))
            hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("${micMute}"))

            -- Media control
            hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${mediaPlayPause}"))
            hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${mediaNext}"))
            hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${mediaPrev}"))

            -- Raise/Lower audio
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${audioIncrease}"), { repeating = true })
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${audioDecrease}"), { repeating = true })

            -- Raise/Lower mic audio
            hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("${micIncrease}"), { repeating = true })
            hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("${micDecrease}"), { repeating = true })

            -- Brightness control
            hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
            hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

            -- Move windows with Super + M1
            hl.bind("SUPER + mouse:272", hl.dsp.window.drag())

            -- Resize windows with Super + M2
            hl.bind("SUPER + mouse:273", hl.dsp.window.resize())
        '';
    };
}

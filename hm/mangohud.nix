{
    programs.mangohud.enable = true;
    # programs.mangohud.enableSessionWide = true;
    programs.mangohud.settings = {
        gpu_text = "GPU";
        gpu_list = [0];
        gpu_stats = true;
        gpu_temp = true;
        gpu_power = true;

        cpu_text = "CPU";
        cpu_stats = true;
        cpu_temp = true;
        cpu_power = true;

        ram = true;
        vram = true;

        fps_text = "FPS";
        fps = true;
        fps_color_change = true;
        fps_value = [60 120];
        frametime = true;
        fps_metrics = true;

        table_columns = 4;
        round_corners = 15;

        toggle_hud = "Shift_R";
    };
}

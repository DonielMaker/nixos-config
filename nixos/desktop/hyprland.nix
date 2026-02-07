{pkgs, ...}:

{
    programs.hyprland.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
        kitty
        nautilus
        hyprpolkitagent
    ];
}

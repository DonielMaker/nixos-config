{pkgs, username, ...}: 

{
    services.greetd.enable = true;
    services.greetd.settings = {
        initial_session = {
            command = "${pkgs.hyprland}/bin/hyprland";
            user = username;
        };
    };

    environment.systemPackages = with pkgs; [
        gtkgreet
    ];
}

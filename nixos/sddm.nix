{pkgs-stable, ...}:

{
    services.displayManager.enable = true;
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-macchiato";
        package = pkgs-stable.libsForQt5.sddm;
    };

    environment.systemPackages = with pkgs-stable; [ 
        (catppuccin-sddm.override {flavor = "macchiato"; loginBackground = true;}) 
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
    ];
}

{pkgs, ...}:

{
    services.displayManager.enable = true;
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-macchiato";
        package = pkgs.kdePackages.sddm;
    };

    environment.systemPackages = with pkgs; [ 
        (catppuccin-sddm.override {flavor = "macchiato"; loginBackground = true;}) 
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
    ];
}

{pkgs, config, ...}:

{
    services.flameshot.enable = true;
    services.flameshot.settings = {
        general = {
            savePath = "${config.home.homeDirectory}/Pictures";
            savePathFixed = true;
            saveAsFileExtension = ".png";
            useGrimAdapter = true;
            showSidePanelButton = false;
        };
    };

    home.packages = with pkgs; [
        grim
    ];
}

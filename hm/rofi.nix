{pkgs, inputs, ...}: 

{
    programs.rofi.enable =  true;
    programs.rofi = {
        terminal = "${pkgs.kitty}/bin/kitty";
        theme = "${pkgs.rofi-clean}/style-1.rasi";
        extraConfig = {
            modi = "drun,calc";
        };
        plugins = with pkgs; [
           rofi-calc 
        ];
    };

    home.packages = [pkgs.libqalculate];
}

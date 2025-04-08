{pkgs, inputs, ...}: 

{
    programs.rofi.enable =  true;
    programs.rofi = {
        terminal = "${pkgs.kitty}/bin/kitty";
        # theme = "${inputs.self.packages."x86_64-linux".rofi-catppuccin}/catppuccin-macchiato.rasi";
        theme = "${inputs.self.packages."x86_64-linux".rofi-spotlight}/spotlight-dark.rasi";
        extraConfig = {
            modi = "drun,calc";
        };
        plugins = with pkgs; [
           rofi-calc 
        ];
    };

    home.packages = [pkgs.libqalculate];
}

{...}: 

{
    boot.loader.limine.enable = true;
    boot.loader.limine = {
        efiSupport = true;
        style = {
            wallpapers = [];
            interface.branding = "I use NixOS btw";
            graphicalTerminal.background = "24283b";
            graphicalTerminal.foreground = "c0caf5";
            graphicalTerminal.palette = "
                :24283b
                :f7768e
                :9ece6a
                :ff9e64
                :7aa2f7
                :bb9af7
                :7dcfff
                :2F334C
            ";
        };
        maxGenerations = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;
}


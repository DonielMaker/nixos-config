{...}: 

{
    boot.loader.limine.enable = true;
    boot.loader.limine = {
        efiSupport = true;
        style = {
            wallpapers = [
                # TODO: MOVE THIS PHOTO TO A DERIVATION!!
                ./vladislav-klapin-o-SMjjGuP6c-unsplash.jpg            
            ];
            interface.resolution = "1920x1080";
            interface.branding = "I use NixOS btw";
            graphicalTerminal.background = "ff000000";
            graphicalTerminal.foreground = "c0caf5";
            graphicalTerminal.margin = 50;
        };
        maxGenerations = 50;
    };
    boot.loader.efi.canTouchEfiVariables = true;
}


{lib, image, ...}: 

{
    boot.loader.limine.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
        efiSupport = true;
        maxGenerations = 10;
        style = {
            wallpapers = [ "${image.boot}" ];
            interface.branding = "I use NixOS btw";
            graphicalTerminal.background = lib.mkForce "FFFFFFFF";
        };
    };
}


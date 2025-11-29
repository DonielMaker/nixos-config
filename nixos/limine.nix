{pkgs, ...}: 

let
    image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/vladislav-klapin-o-SMjjGuP6c-unsplash.jpg";
        sha256 = "sha256-+ObY8Jft/Ergnufgcp/cXKV/webd+74yl1XdsCYdMp0=";
    };
in

{
    boot.loader.limine.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
        efiSupport = true;
        maxGenerations = 10;
        style = {
            wallpapers = [ "${image}" ];
            interface.branding = "I use NixOS btw";
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
    };
}


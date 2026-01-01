{pkgs}:

{
    hostname = "galaxia";
    username = "donielmaker";
    mail = "daniel.schmidt0204@gmail.com";
    monitor = ", 1920x1080@60hz, auto, 1";
    shell = "zsh";
    image = {
        pfp = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/9d3e6bb09f9d2745b6224511c7ef3a025666d04a/Matt.jpg";
            sha256 = "sha256-qIzNEhdXCAfhSZiGqzOdwgcheESpYggVWTj+NfhRQKU=";
        };
        boot = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/vladislav-klapin-o-SMjjGuP6c-unsplash.jpg";
            sha256 = "sha256-+ObY8Jft/Ergnufgcp/cXKV/webd+74yl1XdsCYdMp0=";
        };
        login = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/rohit-tandon-9wg5jCEPBsw-unsplash.jpg";
            sha256 = "sha256-qSUv2rCHWB2fYwL2Gd8d8LeQKKtM4aEljshaFbirB0g=";
        };
    };
}

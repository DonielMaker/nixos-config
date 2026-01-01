{pkgs}:

{
    hostname = "zenith";
    username = "donielmaker";
    mail = "daniel.schmidt0204@gmail.com";
    monitor = ["DP-1, 2560x1440@144hz, auto, 1" "DP-2, 1920x1080@180hz, auto-left, 1, transform, 3"];
    timezone = "Europe/Berlin";
    shell = "zsh";
    domain = "thematt.net";
    image = {
        pfp = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/Matt.jpg";
            sha256 = "sha256-qIzNEhdXCAfhSZiGqzOdwgcheESpYggVWTj+NfhRQKU=";
        };
        boot = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/vladislav-klapin-o-SMjjGuP6c-unsplash.jpg";
            sha256 = "sha256-+ObY8Jft/Ergnufgcp/cXKV/webd+74yl1XdsCYdMp0=";
        };
        login = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/refs/heads/main/konstantin-kleine-V1NVvXmO_dk-unsplash.jpg";
            sha256 = "sha256-gOdgMuuQM//G7lfpaKooa27ij2Ph5RaXNRH9Gc0QrHc=";
        };
    };
}

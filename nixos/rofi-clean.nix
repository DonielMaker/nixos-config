{
    stdenv,
    fetchFromGitHub,
    ...
}: 

stdenv.mkDerivation {
    pname = "rofi-clean";
    version = "1.0.0";

    src = fetchFromGitHub {
        owner = "adi1090x";
        repo = "rofi";
        rev = "b76c16b2b7c465d7b082e11e5210fcd10c6683a7";
        hash = "sha256-9IHENxHQors2z3aYj/xToZD79Gmi1aqlE3QnKnvOT9A=";
    };

    installPhase = ''
        mkdir -p $out

        sed -i 's/    background:     #1E1D2FFF;/    background:     #24273aFF;/g' ./files/colors/catppuccin.rasi
        sed -i 's/@import                          "shared\/colors.rasi"/@import                          "catppuccin.rasi"/g' ./files/launchers/type-2/style-1.rasi
        sed -i 's/@import                          "shared\/fonts.rasi"/@import                          "fonts.rasi"/g' ./files/launchers/type-2/style-1.rasi

        cp ./files/launchers/type-2/style-1.rasi ./files/colors/catppuccin.rasi ./files/applets/shared/fonts.rasi $out
    '';
}


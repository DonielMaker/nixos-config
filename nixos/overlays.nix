{pkgs, ...}: [
    (final: prev: {
        rofi-spotlight = pkgs.callPackage ./rofi-spotlight.nix {};
        rofi-clean = pkgs.callPackage ./rofi-clean.nix {};
    })
]

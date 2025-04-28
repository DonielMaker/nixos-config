{pkgs, ...}: [
    (final: prev: {
        rofi-spotlight = pkgs.callPackage ./rofi-spotlight.nix {};
    })
]

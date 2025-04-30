{pkgs}:

pkgs.mkShell rec {
    buildInputs = with pkgs;[
        rustc
        cargo
        cargo-watch
        openssl
        rust-analyzer
        pkg-config
        wayland
        libGL
        libxkbcommon
    ];

    # Winit needs to know where the wayland backend config is located 
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
    RUST_BACKTRACE = "full";
}

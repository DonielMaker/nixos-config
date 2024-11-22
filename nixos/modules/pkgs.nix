#  WARN: Packages might be defined elsewhere via programs.<name>
#  WARN: when defining config with home-manager make sure the pkgs in home-manager are the same

{ config, pkgs-stable, pkgs, ... }: {
    environment.systemPackages = with pkgs-stable; [
        # Text Editors
        vim
        pkgs.neovim
        # CLI Tools
        alacritty
        kitty
        zsh
        git
        lazygit
        gh
        ripgrep
        fd
        fzf
        chafa
        unzip
        fastfetch
        htop
        eza
        ffmpeg
        # Programming doodads
        zig
        rustc
        cargo
        nodejs_22
        gnumake
        openssl
        pkg-config
        # Wayland
        waybar
        wofi
        eww
        swww
        hyprcursor
        xwayland
        wl-clipboard
        cliphist
        # Audio
        pipewire
        wireplumber
        pavucontrol
        pamixer
        # Programs
        vesktop
        firefox
        pkgs.nemo
        prismlauncher
        # Other
        catppuccin-qt5ct
        openrgb-with-all-plugins
        tokyonight-gtk-theme
        home-manager
    ];
    
    fonts.packages = with pkgs; [
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
}

{pkgs, ...}:

{
    programs.zsh.enable = true;
    programs.zsh.promptInit = "fastfetch";
    environment.pathsToLink = [ "/share/zsh" ];
    
    environment.systemPackages = with pkgs; [
        # CLI Tools
        vim
        gcc
        cargo
        rustc
        jq
        kitty
        zsh
        git
        lazygit
        ripgrep
        bat
        fd
        fzf
        unzip
        fastfetch
        htop
        eza
        ffmpeg
        tmux
        nmap
        imagemagick
        pkg-config
    ];

    fonts.packages = with pkgs; [
        nerd-fonts.fira-code
    ];
}

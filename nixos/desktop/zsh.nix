{pkgs, ...}:

{
    programs.zsh.enable = true;
    programs.zsh.promptInit = "fastfetch";
    environment.pathsToLink = [ "/share/zsh" ];
    programs.zsh.interactiveShellInit = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
    
    environment.systemPackages = with pkgs; [
        # CLI Tools
        vim
        just
        htop
        yt-dlp
        imagemagick
        ghostscript
        git
        lazygit
        ripgrep
        fd
        fzf
        unzip
        fastfetch
        eza
        ffmpeg
    ];
    
    fonts.packages = with pkgs; [
        nerd-fonts.fira-code 
    ];
}

{ config, lib, pkgs, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.zsh;
in

{
    options.modules.terminal.zsh.enable = mkEnableOption "Enable Zsh";

    config = mkIf cfg.enable {

        programs.zsh.enable = true;
        # Start fastfetch when Terminal opens (Kinda like a dashboard)
        programs.zsh.promptInit = "fastfetch";
        environment.pathsToLink = [ "/share/zsh" ];
        # Enable zsh-vi-mode
        programs.zsh.interactiveShellInit = ''
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '';

        environment.systemPackages = with pkgs; [
            eza # Better ls
            fd # Better find
            fzf # Fuzzy finder
            ffmpeg # Record, convert and stream audio and video files
            fastfetch # System information tool
            ghostscript # PostScript/PDF interpreter
            git # git
            htop # Process and System manager
            imagemagick # Convert, edit, compose image files
            just # Command runner 
            lazygit # Git tui
            ripgrep # Better grep
            unzip # Working with .zip files
            vim # vim
            yt-dlp # Download Youtube videos
        ];
    };
}

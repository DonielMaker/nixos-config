{ config, lib, pkgs, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.zsh;
in

{
    options.modules.terminal.zsh.enable = mkEnableOption "Enable Zsh";

    config = mkIf cfg.enable {

        programs.zsh.enable = true;
        users.users.${config.settings.username}.shell = pkgs.zsh;

        environment.systemPackages = with pkgs; [
            eza # Better ls
            fastfetch # System information tool
            fd # Better find
            ffmpeg # Record, convert and stream audio and video files
            fzf # Fuzzy finder
            ghostscript # PostScript/PDF interpreter
            git # git
            htop # Process and System manager
            imagemagick # Convert, edit, compose image files
            just # Command runner 
            lazygit # Git tui
            openssl # Cryptography
            ripgrep # Better grep
            unzip # Working with .zip files
            vim # vim
            wget # http client
            yt-dlp # Download Youtube videos
        ];
    };
}

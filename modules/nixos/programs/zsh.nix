{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.zsh;
in

{
    options.modules.programs.zsh.enable = mkEnableOption "Enable Zsh";

    config = mkIf cfg.enable {

        programs.zsh.enable = true;
        programs.zsh.promptInit = "fastfetch";
        environment.pathsToLink = [ "/share/zsh" ];
        programs.zsh.interactiveShellInit = ''
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            '';

        environment.systemPackages = with pkgs; [
            # CLI Tools
            eza
            fd
            fzf
            ffmpeg
            fastfetch
            ghostscript
            git
            htop
            imagemagick
            just
            lazygit
            ripgrep
            unzip
            vim
            yt-dlp
        ];
    };
}

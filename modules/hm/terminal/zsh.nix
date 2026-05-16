{ config, lib, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.zsh;
in

{
    options.modules.terminal.zsh.enable = mkEnableOption "Enable Zsh";

    config = mkIf cfg.enable {

        programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            shellAliases = {
                ".." = "cd ..";
                "..." = "cd ../..";
                "...." = "cd ../../..";
                "....." = "cd ../../../..";
                z = "zellij";
                grep = "rg";
                s = "ragenix -e";
                lg = "lazygit";
                v = "nvim";
                vim = "nvim";
                ls = "eza -a --icons=auto";
                ff = "fastfetch";
            };
        };
    };
}

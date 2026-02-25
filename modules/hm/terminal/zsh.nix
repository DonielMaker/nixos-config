{ config, lib, ...}:

let
    module = "Zsh";
    cfg = config.modules.hm.zsh;
in with lib;

{
    options.modules.hm.zsh.enable = mkEnableOption "Enable ${module}";

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

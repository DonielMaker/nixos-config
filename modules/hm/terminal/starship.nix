{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.starship;
in

{
    options.modules.terminal.starship.enable = mkEnableOption "Enable Starship";

    config = mkIf cfg.enable {

        programs.starship.enable = true;
        programs.starship.settings = {
            format = ''
                $hostname$directory$git_branch$git_status$character
                ❯
            '';

            directory = {
                truncate_to_repo = false; 
            };

            hostname = {
                style = "bold green";
                ssh_only = false;
            };

            git_status = {
                format = "([\\[$all_status$ahead_behind\\]]($style) )";
                modified = "[!$count](bold orange)";
                staged = "[+$count](bold green)";
                renamed = "[»$count](bold purple)";
                deleted = "[✘$count](bold red)";
                untracked = "[?$count](bold white)";
            };

            character = {
                success_symbol = "[](bold green)";
                error_symbol = "[](bold red)";
                vimcmd_symbol = "[](bold green)";
            };
        };
    };
}

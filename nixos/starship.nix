{...}:

{
    programs.starship.enable = true;
    programs.starship.settings = {
        format = ''
            $hostname$directory$rust$git_branch$git_commit
            ❯
        '';

        directory = {
            truncate_to_repo = false; 
        };

        hostname = {
            style = "bold green";
            ssh_only = false;
        };
    };
}

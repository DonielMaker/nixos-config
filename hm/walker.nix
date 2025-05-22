{pkgs-stable, inputs, system, ...}: 

{
    programs.walker.enable = true;
    programs.walker = {
        package = pkgs-stable.walker;
        runAsService = true;
        config = {
            dmenu.LabelColumn = 3;
        };
        # theme.layout = import ../testing/theme.toml;
        # theme.style = import ../testing/style.css;
    };
}

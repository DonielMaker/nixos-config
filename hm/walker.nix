{pkgs, inputs, system, ...}: 

{
    programs.walker.enable = true;
    programs.walker = {
        # package = inputs.walker.packages.${system}.default;
        package = pkgs.walker;
        config = {
            dmenu.LabelColumn = 3;
        };
    };
}

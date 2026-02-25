{lib, ... }: 

with lib;

{
    options.modules.hm = {

        username = mkOption {
            default = "user";
            type = types.str;
            description = "Sets the username of the Home-manager User";
        };

        keyboard.layout = mkOption {
            default = "de";
            type = types.str;
            description = "Sets the Keyboard layout in Hyprland";
        };

        mail = mkOption {
            default = "test@example.com";
            type = types.str;
            description = "Email used for for example git";
        };
    };
}

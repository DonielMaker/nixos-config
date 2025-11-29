{ username, ...}: {
    programs.firefox.enable = true;

    programs.firefox = {

        profiles.${username} = {
            search = {
                force = true;
                default = "ddg";
                privateDefault = "ddg";
                # engines = {
                #     "Nix Packages" = {
                #         urls = [{
                #             template = "https://search.nixos.org/packages";
                #             params = [
                #             {name = "type"; value = "packages";}
                #             {name = "query"; value = "{searchTerms}";}
                #             ];
                #         }];
                #
                #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                #         definedAliases = [ "@np" ];
                #     };
                #
                #     "HM Packages" = {
                #         urls = [{
                #             template = "https://home-manager-options.extranix.com/";
                #             params = [
                #             {name = "type"; value = "packages";}
                #             {name = "query"; value = "{searchTerms}";}
                #             ];
                #         }];
                #
                #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                #         definedAliases = [ "@hm" ];
                #     };
                # };
            };
        };
    };
}

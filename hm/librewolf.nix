{ pkgs, username, ...}: {
    programs.librewolf.enable = true;

    programs.librewolf = {

        profiles.${username} = {
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                bitwarden
                darkreader
            ];
            containers = {
                dangerous = {
                    color = "red";
                    icon = "fruit";
                    id = 2;
                };
                shopping = {
                    color = "blue";
                    icon = "cart";
                    id = 1;
                };
            };
            search = {
                force = true;
                default = "ddg";
                privateDefault = "ddg";
                engines = {
                    "Nix Packages" = {
                        urls = [{
                            template = "https://search.nixos.org/packages";
                            params = [
                            {name = "type"; value = "packages";}
                            {name = "query"; value = "{searchTerms}";}
                            ];
                        }];

                        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        definedAliases = [ "@np" ];
                    };

                    "HM Packages" = {
                        urls = [{
                            template = "https://home-manager-options.extranix.com/";
                            params = [
                            {name = "type"; value = "packages";}
                            {name = "query"; value = "{searchTerms}";}
                            ];
                        }];

                        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        definedAliases = [ "@hm" ];
                    };
                };
            };
        };
    };
}

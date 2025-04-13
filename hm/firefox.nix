{ pkgs, pkgs-firefox, username, ...}: {
    programs.firefox.enable = true;

    programs.firefox = {

        profiles.${username} = {
            search = {
                force = true;
                default = "DuckDuckGo";
                privateDefault = "DuckDuckGo";
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
                };
            };

# extensions = with pkgs-firefox;[
#     bitwarden
#     ublock-origin
#     sponsorblock
# ];
        };
    };
}

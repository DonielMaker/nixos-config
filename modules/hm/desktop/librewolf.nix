{ config, lib, pkgs, ...}:

let
    module = "Librewolf";
    cfg = config.modules.hm.librewolf;
in with lib;

{
    options.modules.hm.librewolf.enable = mkEnableOption "Enable ${module}";

    config = mkIf cfg.enable {

        programs.librewolf.enable = true;
        programs.librewolf = {

            profiles.${config.modules.hm.username} = {
                extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    bitwarden
                    darkreader
                    foxyproxy-standard
                    multi-account-containers
                ];

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
    };
}

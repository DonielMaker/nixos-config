{ config, lib, pkgs, modules, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.programs.librewolf;
in

{
    options.modules.programs.librewolf.enable = mkEnableOption "Enable Librewolf";

    config = mkIf cfg.enable {

        programs.librewolf.enable = true;
        programs.librewolf = {

            profiles.${modules.system.username} = {
                extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    bitwarden
                    darkreader
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

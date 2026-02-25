{ config, lib, sLib, inputs, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.desktop.stylix;
in

{
    options.modules.desktop.stylix.enable = mkEnableOption "Enable Stylix";

    imports = [ inputs.stylix.nixosModules.default ];

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

        stylix.enable = true;
        stylix = {
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

            polarity = "dark";

            cursor = {
                name = "Bibata-Modern-Ice";
                package = pkgs.bibata-cursors;
                size = 24;
            };

            icons.enable = true;
            icons = {
                light = "Papirus";
                dark = "Papirus-Dark";
                package = pkgs.papirus-icon-theme;
            };

            fonts = {
                sansSerif = {
                    name = "CommitMono Nerd Font";
                    package = pkgs.nerd-fonts.commit-mono;
                };
                serif = {
                    name = "GoMono Nerd Font";
                    package = pkgs.nerd-fonts.go-mono;
                };
                monospace = {
                    name = "FiraCode Nerd Font";
                    package = pkgs.nerd-fonts.fira-code;
                };
                # monospace = {
                #     name = "CascaydiaCove Nerd Font";
                #     package = pkgs.nerd-fonts.caskaydia-cove;
                # };
            };

            # Doesn't work with nixos logo
            targets.plymouth.logoAnimated = false;

            targets.limine.image.enable = false;
        };
    };
}

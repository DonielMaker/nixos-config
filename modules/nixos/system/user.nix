{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.system.user;
in

{
    options.modules.system.user.enable = mkEnableOption "Enable User";

    config = mkIf cfg.enable {

        nix.settings.trusted-users = [ config.settings.username ];

        users.users.${config.settings.username} = {
            isNormalUser = true;
            initialPassword = "Changeme";

            extraGroups = ["networkmanager" "wheel" "input" "audio"];
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia"
            ];
        };
    };
}

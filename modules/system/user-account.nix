{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.system.user;
in

{
    options.modules.system.user.enable = mkEnableOption "Enable User";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.system.enable)
        ];

        nix.settings.trusted-users = [ config.modules.system.username ];

        users.users.${config.modules.system.username} = {
            isNormalUser = true;
            description = config.modules.system.username;
            extraGroups = ["networkmanager" "wheel" "input" "audio"];
            shell = config.modules.system.shell;
            initialPassword = "Changeme";
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia"
            ];
        };
    };
}

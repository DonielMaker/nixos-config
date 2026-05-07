{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.system.admin;
in

{
    options.modules.system.admin.enable = mkEnableOption "Enable the Admin Account (Solut)";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.system.enable)
        ];

        nix.settings.trusted-users = [ "solut" ];

        users.users.solut = {
            isNormalUser = true;
            description = "Admin Account";
            extraGroups = ["networkmanager" "wheel" "input" "audio"];
            shell = pkgs.bash;
            initialPassword = "Changeme";
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILeOq3JuU6hbm+MTy1hoXV56RtaDPIsTGYihEQV/NCv7 donielmaker@usr-don-1"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkeKH+HNssMqFFvlRcTPy/AQnYp3jdsGj0UJ8KbMOyG deuyanon@mpc-01"
            ];
        };
    };
}

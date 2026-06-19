{ config, lib, pkgs, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.bind;
in

{
    options.modules.server.bind.enable = mkEnableOption "Enable Bind";

    config = mkIf cfg.enable {
        networking.firewall.allowedUDPPorts = [ 53 ];

        # Bind9: DNS Server
        services.bind.enable = true;
        services.bind.zones.${config.modules.server.domain} = {
            master = true;
            file = pkgs.writeText "${config.modules.server.domain}.zone" ''
$TTL 2d    ; default TTL for zone

$ORIGIN ${config.modules.server.domain}.

; Start of Authority RR defining the key characteristics of the zone (${config.modules.server.domain})

@                   IN      SOA   ns.${config.modules.server.domain}. daniel.schmidt0204.gmail.com (

        2025111000; serial number
        12h        ; refresh
        15m        ; update retry
        3w         ; expiry
        2h         ; minimum
        )

@                   IN      NS      ns

ns                  IN      A       10.10.12.10

; === Auth Server ===
miasma              IN      CNAME   ns

*                   IN      CNAME   miasma

; === Main Server ===
lastprism           IN      A       10.10.12.11

; === Vyos Router ===
vilethorn           IN      A       10.10.10.1        

; === Proxmox Server ===
apathanull          IN      A       10.10.12.12

; === Misc ===
gameserver          IN      A       10.10.12.102

mail                IN      CNAME   eu1.workspace.org.
'';
        };
    };
}

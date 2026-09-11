{ lib, ... }:

# Used in all the other modules

let
    inherit (lib) mkEnableOption;
in

{
    options.modules.server.monitoring.enable = mkEnableOption "Enable Grafana Stack";
}

{pkgs-stable, ...}:

{
    programs.coolercontrol.enable = true;

    environment.systemPackages = with pkgs-stable.coolercontrol; [ coolercontrold coolercontrol-gui coolercontrol-ui-data coolercontrol-liqctld ];
}

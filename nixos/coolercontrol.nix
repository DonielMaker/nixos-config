{pkgs, ...}:

{
    programs.coolercontrol.enable = true;

    environment.systemPackages = with pkgs.coolercontrol; [ 
        coolercontrold 
        coolercontrol-gui 
        coolercontrol-ui-data 
        # coolercontrol-liqctld 
    ];
}

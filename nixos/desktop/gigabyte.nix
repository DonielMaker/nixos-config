# This modules enables the it87 kernel drivers which allows fan control in gigabyte (and some other) motherboards 
{config, ...}:

{

    boot.kernelModules = [ "it87" "coretemp" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
        it87
    ];
    boot.kernelParams = [ "acpi_enforce_resources=lax" ];
    boot.extraModprobeConfig = ''
        options it87 force_id=0x8628
    '';
}

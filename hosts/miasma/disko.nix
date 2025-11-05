{
    disko.devices.disk = {
        main = {
            device = "/dev/disk/by-id/ata-SAMSUNG_MZNLF128HCHP-00000_S28TNXAGB04908";
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        type = "EF00";
                        size = "500M";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                        };
                    };
                    root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                        };
                    };
                };
            };
        };
    };
}

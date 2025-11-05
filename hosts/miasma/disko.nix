{
    disko.devices.disk = {
        main = {
            device = "/dev/disk/by-id/nvme-KINGSTON_SA1000M8480G_50026B7282087FAB";
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

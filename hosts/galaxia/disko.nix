{
    disko.devices.disk.main = {
        device = "/dev/disk/by-id/nvme-Lexar_SSD_NM790_1TB_PKG257R003231P220J";
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
}

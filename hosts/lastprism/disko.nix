{
    disko.devices.disk = {
        main = {
            device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
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

        disk1 = {
            device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1";
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    opencloud = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/var/lib/opencloud";
                        };
                    };
                };
            };
        };
    };
}

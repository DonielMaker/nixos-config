{drive ? throw "please select a device", ...}:

{
    disko.devices.disk.main = {
        device = drive;
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
                test = {
                    size = "128G";
                    content = {
                        type = "filesystem";
                        format = "nfs";
                        mountpoint = "/var/lib/nfs";
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

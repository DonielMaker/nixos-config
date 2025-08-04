{
    disko.devices.disk = {
        main = {
            device = "/dev/disk/by-id/nvme-CT1000T500SSD8_234244BFF180";
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
        games = {
            device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S2000G_50026B778534679F";
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    games = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/mnt/games";
                            mountOptions = [ "users" "nofail" "exec" ];
                        };
                    };
                };
            };
        };
    };
}

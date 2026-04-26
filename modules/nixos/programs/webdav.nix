{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.webdav;

    mountpoint = "/home/${config.modules.system.username}/webdav";
    rcloneOptions = [
        "rw"
        "allow_other" # Allows other users than root to rw
        "args2env" # Required by Rclone
        "_netdev" # Makes this a network dependant device
        "vfs-cache-mode=writes" # Allows Rclone to use VFS (Virtual Filesystem) for local files before sending to server
        "cache-dir=/var/rclone" # Required by vfs-cache-mode
        # Sets the rclone.conf.
        # Make sure your rclone remote is stored there. Otherwise this won't work
        "config=/home/${config.modules.system.username}/.config/rclone/rclone.conf" 
        "uid=1000"
        "gid=100"
    ];
in

{
    options.modules.programs.webdav.enable = mkEnableOption "Enable Webdav Mount";

    config = mkIf cfg.enable {

        programs.fuse.enable = true;
        programs.fuse.userAllowOther = true;

        systemd.mounts = [
            {
                description = "Webdav Mount";
                after = ["network-online.target"];
                wants = ["network-online.target"];

                # Make sure this exists in ~/.config/rclone/rclone.conf
                what = "webdav:";
                where = mountpoint;

                # Combines it into "value1,value2,..."
                options = builtins.concatStringsSep "," rcloneOptions;
                # fuse.rclone seems to be better suited but doesn't work as rclone is not found as a command
                type = "rclone";
            } 
        ];

        systemd.automounts = [
            {
                description = "Webdav Automount";

                where = mountpoint;

                wantedBy = [ "multi-user.target" ];

                # unmount after 10 min idle (optional)
                automountConfig.TimeoutIdleSec = "600"; 
            }
        ];

        environment.systemPackages = with pkgs; [ rclone ];
    };
}


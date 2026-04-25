let
    donielmaker-galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia";
    users = [donielmaker-galaxia];

    galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkebkctZ2f6Df+ujM9XOeDSGteb5QNT8TowV4aEjINK";
    systems = [galaxia];
in

{
    "webdav-secret.age".publicKeys = users ++ systems;
}

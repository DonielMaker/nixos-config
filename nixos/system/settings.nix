{timezone, ...}:

{
    time.timeZone = timezone;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

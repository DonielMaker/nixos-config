{timezone, ...}:

{
    time.timeZone = timezone;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    i18n.defaultLocale = "en_US.UTF-8";
}

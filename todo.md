things to do:

- Many Client Services are Duplicates. This includes:
    - Printing
    - Keyboard Layout
    - plymouth
    - nautilus-open-any-terminal
    - gvfs
    - localsend

- Many "Modules" don't work as modules but just for saving space in the configuration.nix. This includes:
    - Graphics.nix

- Many Values are hard-set instead of usable variables. Possible Refactors are:
    - Domainname (thematt.net)
    - Keyboard Layout
    - Nameservers
    - Possibly some hard-coded ip (Trustedproxies, etc.)

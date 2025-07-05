# Changes (tbm) for the individual hosts:
- Change settings.nix to be module compliant (allows for some more niche things like error handling)
- Create following host architecture:
    - configuration.nix (main config where host specific changes like installed pkgs/modules are created)
    - home.nix (same but for the user)
    - disko.nix (disk handling should be individual for each host instead of what is is now)
    - secrets management (TODO!)
- instead of a settings.nix file reuse nix config.xyz configuration

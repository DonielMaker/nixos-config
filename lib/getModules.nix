{lib}:

let
    getFile = dir: lib.filesystem.listFilesRecursive dir;
    getNixFile = dir: lib.filter (file: lib.hasSuffix ".nix" file) (getFile dir);
    getBaseFile = dir: lib.map (file: baseNameOf file) (getNixFile dir);
    getModuleName = dir: lib.map (file: lib.removeSuffix ".nix" file) (getBaseFile dir);
    zipPairs = dir: map(attr: {name = attr.fst; value = attr.snd;}) (lib.zipLists (getModuleName dir) (getNixFile dir));
in dir: builtins.listToAttrs (zipPairs dir)

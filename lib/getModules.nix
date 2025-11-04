{lib}:

# Turns a directory like such:
#
# test
# ├── dir1
# │   ├── dir1file1.nix
# │   ├── dir1file2.nix
# │   └── dir1file3.nix
# ├── file1.nix
# ├── file2.nix
# ├── file3.nix
# └── file4.nix
#
# Into an attrSet like this:
# 
# {
#     file1 = /test/file1.nix; 
#     file2 = /test/file2.nix; 
#     file3 = /test/file3.nix; 
#     file4 = /test/file4.nix; 
#     dirfile1 = /test/dir1/dirfile1.nix;
#     dirfile2 = /test/dir1/dirfile2.nix;
#     dirfile3 = /test/dir1/dirfile3.nix;
# }

let
    # Returns a flatted directory
    getFlatDir = dir: lib.filesystem.listFilesRecursive dir;
    # Gets all the File with a certain suffix
    getFileWithSuffix = dir: suffix: lib.filter (file: lib.hasSuffix suffix file) (getFlatDir dir);
    # Return the file name (aka module name) of a path
    getModuleName = dir: suffix: lib.map (file: lib.removeSuffix suffix (baseNameOf file)) (getFileWithSuffix dir suffix);
    # Zips two lists into a list of attrSet like so: [{name = name; value = value;} ...]
    zipPairs = dir: suffix: lib.zipListsWith (moduleName: modulePath: lib.nameValuePair moduleName (if (lib.pathIsDirectory modulePath) then (toAttrSet modulePath suffix) else modulePath)) (getModuleName dir suffix) (getFileWithSuffix dir suffix);
    # With zipPairs it turns the list into one attrSet like so: {name1 = value1; name2 = value2; ...}
    toAttrSet = dir: suffix: builtins.listToAttrs (zipPairs dir suffix);
in dir: suffix: toAttrSet dir suffix

# Caveats:
# - This uses listFilesRecursive which means: Files can never have the same name (Not even in different Directories!)

# Below is an attempt at keeping directories. This leads to sub modules such as:
# theModule.someFile # is a File
# theModule.someDir # is a Dir
# theModule.someDir.fileInside # is a File

# Note that this is unfinished as i haven't found an replacement for listFilesRecursive. Possible but idc for that.


# let
#     # Returns a flatted directory
#     getFlatDir = dir: lib.filesystem.listFilesRecursive dir;
#     # Gets all the File with a certain suffix
#     getFileWithSuffix = dir: suffix: lib.filter (file: lib.hasSuffix suffix file || lib.pathIsDirectory file) (getFlatDir dir);
#     # Return the file name (In this case the module name) of a path
#     getModuleName = dir: suffix: lib.map (file: lib.removeSuffix suffix (baseNameOf file)) (getFileWithSuffix dir suffix);
#     # Zips two lists into a list of attrSet like so: [{name = name; value = value;} ...]
#     # At this stage we would like to recurse back into this function if value is of type dir. Essentially giving the name of the function it's own attrSet
#     zipPairs = dir: suffix: lib.zipListsWith (moduleName: modulePath: lib.nameValuePair moduleName (if (lib.pathIsDirectory modulePath) then (toAttrSet modulePath suffix) else modulePath)) (getModuleName dir suffix) (getFileWithSuffix dir suffix);
#     # With zipPairs it turns the list into one attrSet like so: {name1 = value1; name2 = value2; ...}
#     toAttrSet = dir: suffix: builtins.listToAttrs (zipPairs dir suffix);
# in dir: suffix: toAttrSet dir suffix

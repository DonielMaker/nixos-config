# What do we want to achieve with this install script?
#
# 1. Get hardware-configuration.nix automatically
# 2. Ask which disk should be used for disko
# 3. Check if all settings are defined.
# 4. if not ask for necessary settings
# 5. install nixos
#
# Also: if everything seems to be supplied (disk exists, settings are configured) 
# then install the system instantly without prompting the user






# OLD:
# set -e
#
# printf "Make sure you have the right disk selected!\nFlake:\t%s\nDisk:\t%s\n\n" "$1" "$2"
#
# # Wait for User to confirm
# while true; do
#   read -r -p "Press Enter to continue..." key
#   if [[ -z "$key" ]]; then
#     break
#   fi
# done
#
# printf "doing evil\n"
#
# #sudo nixos-generate-config --no-filesystems --show-hardware-config | sudo tee ./hosts/"$1"/hardware-configuration.nix
#
# #sudo nix --experimental-features "nix-command flakes" flake check
#
# #sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --arg main "$2" ./nixos/disko.nix --yes-wipe-all-disks
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./nixos/disko.nix --yes-wipe-all-disks
# sudo nixos-install --flake ".#$1"

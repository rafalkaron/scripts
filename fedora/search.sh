# Display help
display_help()
{
echo "Usage: $0 [packet_name...]" && exit
}

if [[ $1 = "-h" ]] || [[ $1 = "--help" ]] || [[ -z "$1" ]]; then
  display_help
fi

# Search Flatpack packages
#flatpak search $1

# Search DNF packages
#sudo dnf search $1

# search homebrew packages
#brew search $1

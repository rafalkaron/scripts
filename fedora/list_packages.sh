# Get homebrew packages 
for brew_package in $(brew list); do
        echo $brew_package
done

# Get flatpak packages
echo $flatpack_package

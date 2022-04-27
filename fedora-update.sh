echo "Updating flatpak packages..."
flatpak update --user

echo "Updating dfn packages..."
sudo dnf upgrade --refresh
sudo dnf offline-upgrade download

echo "Updating homebrew packages..."
brew update
brew upgrade

echo "Checking if a reboot/relog is needed..."
sudo tracer

read -p "If needed, reboot to install the offline updates now? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf offline-upgrade reboot
fi

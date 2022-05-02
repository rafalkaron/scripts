echo "[i] Updating dfn packages..."
sudo dnf upgrade --refresh -y
echo "[i] Updating dnf packages that require a reboot..."
sudo dnf offline-upgrade download

echo "[i] Updating flatpak packages..."
flatpak update -y

echo "[i] Updating homebrew packages..."
brew update
brew upgrade

#echo "Checking if a reboot/relog is needed..."
#sudo tracer

read -p "[?] If needed, reboot to install the offline updates now? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf offline-upgrade reboot
fi

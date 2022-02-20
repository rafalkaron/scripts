flatpak update --user
sudo dnf upgrade
echo "Checking if a reboot/relog is needed"
sudo tracer
sudo dnf offline-upgrade download

read -p "Reboot to install offline updates? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf offline-upgrade reboot
fi

# Display help
if [[ $1 = "-h" ]] || [[ $1 = "--help" ]] || [[ -z "$1" ]]
    then
        echo "Usage: $0 [packet_name...]" && exit
fi

echo "[i] Searching for flatpak packages..."
flatpak search $1
echo "[i] Checking if the $1 flatpak package is installed..."
flatpak list | grep $1

echo "[i] Searching for dnf packages..."
sudo dnf search $1
echo "[i] Checking if the $1 dnf package is installed..."
sudo dnf list | grep $1

echo "[i] Searching for brew packages..."
brew search $1
echo "[i] Checking if the $1 brew package is installed..."
brew list | grep $1

#!/usr/bin/bash

# TODOS:
# * Add a check that ensures that there's an older subvolume for progressive backup
# * Add if that checks how many snapshots there are. If there are less than 3 snapshots, do not delete the oldest one

# Create a snapshot
sudo btrfs subvolume snapshot -r / /.snapshots/full-$(date +%Y%m%d)

# Get the most recent snapshot filename
most_recent_backup=$(ls /.snapshots | tail -1)
oldest_backup=$(ls /.snapshots -r | tail -1)

# Send the new snapshot progressively
sudo btrfs send -p /.snapshots/$most_recent_backup /.snapshots/full-$(date +%Y%m%d) | sudo btrfs receive /run/media/rk/256/snapshots
echo "Sent /.snapshots/full-$(date +%Y%m%d) to /run/media/rk/256/snapshots/full-$(date +%Y%m%d)"

# Remove the oldest backups
sudo btrfs subvolume remove /.snapshots/$oldest_backup
sudo btrfs subvolume remove /run/media/rk/256/snapshots/$oldest_backup
echo "Removed the oldest backups: /.snapshots/$oldest_backup and /run/media/rk/256/snapshots/$oldest_backup"

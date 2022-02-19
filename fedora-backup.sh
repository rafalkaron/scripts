#!/usr/bin/bash

# TODOS:
# * Add a check that ensures that there's an older subvolume for progressive backup
# * Add if that checks how many snapshots there are. If there are less than 3 snapshots, do not delete the oldest one

# DIRS
local_snapshots_dir="/.snapshots"
remote_snapshots_dir="/run/media/rk/256/snapshots"

# FILENAMES
new_backup="full-$(date +%Y%m%d)"
previous_backup=$(ls $local_snapshots_dir | tail -1)
oldest_backup=$(ls $local_snapshots_dir -r | tail -1)

# Create a snapshot
sudo btrfs subvolume snapshot -r / $local_snapshots_dir/$new_backup

# Send the new snapshot progressively
sudo btrfs send -p $local_snapshots_dir/$previous_backup $local_snapshots_dir/$new_backup | sudo btrfs receive $remote_snapshots_dir

# Inform about the results
echo "Local snapshots:"
echo $(ls $local_snapshots_dir)
echo "Remote snapshots:"
echo $(ls $remote_snapshots_dir)

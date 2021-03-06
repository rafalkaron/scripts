#!/usr/bin/bash

# DIRS
local_snapshots_dir="/.snapshots"
remote_snapshots_dir="/run/media/rk/256/snapshots"

# Check if snapshots dirs exists
if [ ! -d "$remote_snapshots_dir" ]; then
  echo "[!] The remote backup directory ($remote_snapshots_dir) does not exist. Exiting..."
  exit 0
fi
if [ ! -d "$local_snapshots_dir" ]; then
  echo "[!] The local backup directory ($local_backup_dir) does not exist. Exiting..."
  exit 0
fi

# FILENAMES
new_backup="full-$(date +%Y%m%d)"
previous_backup=$(ls $local_snapshots_dir | tail -1)
oldest_backup=$(ls $local_snapshots_dir -r | tail -1)
# NUMBER
# NOTE: Root folder is also counted
local_snapshots_number=$(find $local_snapshots_dir -maxdepth 1 -type d | wc -l)
remote_snapshots_number=$(find $remote_snapshots_dir -maxdepth 1 -type d | wc -l)

# Create a snapshot, try to send the snapshot progressively, fallback to non-progressive send

if [[ "$new_backup" != "$previous_backup" ]];
then
  echo "[info] Creating and sending a full system snapshot"
  sudo btrfs subvolume snapshot -r / $local_snapshots_dir/$new_backup && sudo btrfs send -p $local_snapshots_dir/$previous_backup $local_snapshots_dir/$new_backup | sudo btrfs receive $remote_snapshots_dir || sudo btrfs send $local_snapshots_dir/$new_backup | sudo btrfs receive $remote_snapshots_dir

  # Delete local snapshots if their number exceeeds 3
  if (($local_snapshots_number > 3));
  then
    sudo btrfs subvolume delete $local_snapshots_dir/$oldest_backup
  fi

  # Delete remote snapshots if their number exceeds 3
  if (($remote_snapshots_number > 3));
  then
    sudo btrfs subvolume delete $remote_snapshots_dir/$oldest_backup
  fi

  # Inform about the results
  echo "[info] Local snapshots:"
  echo $(ls $local_snapshots_dir)
  echo "[info] Remote snapshots:"
  echo $(ls $remote_snapshots_dir)

  # Deja-dup
  echo "[info] Running an incremental deja-dup backup of ~/"
  deja-dup --backup

else
  echo "[!] A full system snapshot and a deja-dup (duplicity) backup have already been created today. Exiting..."
fi

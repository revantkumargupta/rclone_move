#!/bin/bash

# User-defined variables
remote_name="Drive"
source_dir="Test"
destination_dir="test1"

# Create the destination directory on Google Drive (ignoring errors if it already exists)
rclone mkdir "$remote_name:$destination_dir" >/dev/null 2>&1

# List and move .mkv files from source to destination
rclone lsf --files-only --recursive "$remote_name:$source_dir" | while IFS= read -r file; do 
    if [[ "$file" == *".mkv" ]]; then
        filename=$(basename "$file")
        echo "Moving $file to $destination_dir/$filename"
        if ! rclone moveto "$remote_name:$source_dir/$file" "$remote_name:$destination_dir/$filename"; then
            echo "Failed to move $file"
        else
            echo "Successfully moved $file to $destination_dir/$filename"
        fi
    fi
done

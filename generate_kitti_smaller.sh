#!/bin/bash

# Default size
SIZE=100

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --size) SIZE="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Source and destination directories
SRC_DIR="KITTI"
DEST_DIR="KITTI_smaller"

# Delete destination directory if it exists
rm -rf "$DEST_DIR"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Function to copy files while preserving directory structure
copy_files() {
    local src_dir=$1
    local dest_dir=$2
    local size=$3

    find "$src_dir" -type f | sort | head -n "$size" | while read -r file; do
        dest_file="$dest_dir/${file#$src_dir/}"
        mkdir -p "$(dirname "$dest_file")"
        cp "$file" "$dest_file"
    done
}

# Copy a smaller subset of the KITTI dataset
for subdir in "calib" "image_2" "image_3" "velodyne"; do
    copy_files "$SRC_DIR/testing/$subdir" "$DEST_DIR/testing/$subdir" "$SIZE"
done

for subdir in "calib" "image_2" "image_3" "label_2" "velodyne" "planes"; do
    copy_files "$SRC_DIR/training/$subdir" "$DEST_DIR/training/$subdir" "$SIZE"
done

# Copy and trim ImageSets files
mkdir -p "$DEST_DIR/ImageSets"

for split in "test" "train" "val" "trainval"; do
    awk -v num_files="$SIZE" '{if ($1 < num_files) print $0}' "$SRC_DIR/ImageSets/$split.txt" > "$DEST_DIR/ImageSets/$split.txt"
done

echo "Copied $SIZE files from each subdirectory of $SRC_DIR to $DEST_DIR and trimmed ImageSets files"
#!/bin/bash

# Check if TRAIN_TARGET environment variable exists
if [ -z "$TRAIN_TARGET" ]; then
  echo "Error: TRAIN_TARGET environment variable is not set."
  exit 1
fi

# Function to download data from GCS
download_data() {
    local gcs_path=$1
    local local_destination=$2
    echo "Downloading data from GCS..."
    python /workspace/mmdetection3d/download_from_gcs.py "$gcs_path" "$local_destination"
}

# Download the appropriate dataset based on TRAIN_TARGET
case "$TRAIN_TARGET" in
  lidar)
    echo "Running command for lidar..."
    # Add your command for lidar here
    ;;
  stereo)
    echo "Running command for stereo..."
    download_data "gs://luxonis-internal-datasets-uscentral1/stereo/kitti-stereo-pcl.tar.gz" "/workspace/mmdetection3d/data/kitti-stereo-pcl.tar.gz"
    echo "Extracting data..."
    tar -xzf /workspace/mmdetection3d/data/kitti-stereo-pcl.tar.gz -C /workspace/mmdetection3d/data/
    mv /workspace/mmdetection3d/data/KITTI /workspace/mmdetection3d/data/kitti
    ;;
  smoke)
    echo "Running command for smoke..."
    download_data "gs://luxonis-internal-datasets-uscentral1/stereo/kitti-stereo-pcl-100.tar.gz" "/workspace/mmdetection3d/data/kitti-stereo-pcl-100.tar.gz"
    echo "Extracting data..."
    tar -xzf /workspace/mmdetection3d/data/kitti-stereo-pcl-100.tar.gz -C /workspace/mmdetection3d/data/
    mv /workspace/mmdetection3d/data/KITTI_smaller /workspace/mmdetection3d/data/kitti
    ;;
  *)
    echo "Error: Unknown TRAIN_TARGET value: $TRAIN_TARGET"
    exit 1
    ;;
esac

# Create KITTI with stereo PCL by symlinking all the directories into data/kitti-stereo-pcl, except for 'velodyne',
# which will be replaced with the stereo PCL data 'stereo_pcl'.
# Train
mkdir -p data/kitti-stereo-pcl/training
mkdir -p data/kitti-stereo-pcl/testing
ln -s /workspace/mmdetection3d/data/kitti/training/calib data/kitti-stereo-pcl/training/calib
ln -s /workspace/mmdetection3d/data/kitti/training/image_2 data/kitti-stereo-pcl/training/image_2
ln -s /workspace/mmdetection3d/data/kitti/training/image_3 data/kitti-stereo-pcl/training/image_3
ln -s /workspace/mmdetection3d/data/kitti/training/label_2 data/kitti-stereo-pcl/training/label_2
ln -s /workspace/mmdetection3d/data/kitti/training/planes data/kitti-stereo-pcl/training/planes
ln -s /workspace/mmdetection3d/data/kitti/training/stereo_pcl data/kitti-stereo-pcl/training/velodyne
# Test
ln -s /workspace/mmdetection3d/data/kitti/testing/calib data/kitti-stereo-pcl/testing/calib
ln -s /workspace/mmdetection3d/data/kitti/testing/image_2 data/kitti-stereo-pcl/testing/image_2
ln -s /workspace/mmdetection3d/data/kitti/testing/image_3 data/kitti-stereo-pcl/testing/image_3
ln -s /workspace/mmdetection3d/data/kitti/testing/planes data/kitti-stereo-pcl/testing/planes
ln -s /workspace/mmdetection3d/data/kitti/testing/stereo_pcl data/kitti-stereo-pcl/testing/velodyne
# ImageSets
ln -s /workspace/mmdetection3d/data/kitti/ImageSets data/kitti-stereo-pcl/ImageSets

# Preprocess KITTI for mmdet3d
python tools/create_data.py kitti --root-path ./data/kitti --out-dir ./data/kitti --extra-tag kitti --with-plane

# Preprocess KITTI for mmdet3d with stereo PCL
python tools/create_data.py kitti --root-path ./data/kitti-stereo-pcl --out-dir ./data/kitti-stereo-pcl --extra-tag kitti --with-plane

# Switch based on the value of TRAIN_TARGET
case "$TRAIN_TARGET" in
  lidar)
    echo "Running command for lidar..."
    # Add your command for lidar here
    ;;
  stereo)
    echo "Running command for stereo..."
    python tools/train.py configs/pointpillars/pointpillars_hv_secfpn_8xb6-160e_kitti-stereo-pcl-3d-3class.py
    ;;
  smoke)
    echo "Running command for smoke..."
    python tools/train.py configs/pointpillars/pointpillars_hv_secfpn_8xb6-160e_kitti-stereo-pcl-3d-3class_5epochs.py
    ;;
  *)
    echo "Error: Unknown TRAIN_TARGET value: $TRAIN_TARGET"
    exit 1
    ;;
esac
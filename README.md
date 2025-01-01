# MMDetection3D Project

This repository contains various experiments regarding 3D detection, utilizing mmdet3d, which is an open-source toolbox for 3D object detection based on PyTorch. It is a part of the OpenMMLab project.

## Installation

To install the project, follow these steps:

1. Clone the repository recursively to include submodules:

    ```sh
    git clone --recursive https://github.com/CaptainTrojan/stereo-pcl-3d.git
    ```

2. Install the required dependencies:

    ```sh
    pip install -r requirements.txt
    ```

## Usage

To use the project, you can run various scripts and tools provided in the repository. Below are some useful scripts and their descriptions.

## Useful Scripts

### Generate KITTI Smaller Dataset

The `generate_kitti_smaller.sh` script allows you to create a smaller subset of the KITTI dataset for testing purposes. You can specify the size of the subset using the `--size` parameter.

```sh
./generate_kitti_smaller.sh --size 100
```

### Download Data from Google Cloud Storage

The `download_from_gcs.py` script allows you to download data from Google Cloud Storage.

```sh
python download_from_gcs.py --bucket your-bucket-name --destination ./data
```

### Entrypoint Script

The `entrypoint.sh` script is used to set up the environment and run various commands based on the `TRAIN_TARGET` environment variable.

```sh
bash entrypoint.sh
```

## Run Examples

### Generate KITTI Stereo PCL (Full, Train)

This command generates the point cloud data for the full KITTI training dataset.

```bash
python mmdetection3d/tools/kitti_stereo_pcl_gen.py KITTI/training
```

### Generate KITTI Stereo PCL (Full, Test)

This command generates the point cloud data for the full KITTI testing dataset.

```bash
python mmdetection3d/tools/kitti_stereo_pcl_gen.py KITTI/testing
```

### Generate KITTI Stereo PCL (Smaller, Train)

This command generates the point cloud data for a smaller subset of the KITTI training dataset.

```bash
python mmdetection3d/tools/kitti_stereo_pcl_gen.py KITTI_smaller/training
```

### Generate KITTI Stereo PCL (Smaller, Test)

This command generates the point cloud data for a smaller subset of the KITTI testing dataset.

```bash
python mmdetection3d/tools/kitti_stereo_pcl_gen.py KITTI_smaller/testing
```

### Generate KITTI Stereo PCL (Train, Max 5)

This command generates the point cloud data for a maximum of 5 samples from the smaller KITTI training dataset.

```bash
python mmdetection3d/tools/kitti_stereo_pcl_gen.py KITTI_smaller/training --max_samples 5
```

### Visualize Point Cloud Data

The following commands visualize the point cloud data for samples in the smaller KITTI training dataset. These commands can be used to compare the stereo point cloud data with the normal LiDAR data.

#### Parameters:
- `--show_lidar_with_depth`: Show LiDAR data with depth information.
- `--const_box`: Display constant bounding boxes.
- `--vis`: Enable visualization mode.
- `-d`: Specify the dataset directory.
- `-l`: Specify the label type (e.g., `stereo_pcl` for stereo point cloud data). If unspecified, shows lidar PCLs.
- `-i`: Specify the index of the sample to visualize.

#### Visualize Stereo Point Cloud Data

These commands visualize the stereo point cloud data for the specified sample indices.

##### Visualize (Train, Index 0)

```bash
python kitti_object_vis/kitti_object.py --show_lidar_with_depth --const_box --vis -d KITTI_smaller -l stereo_pcl -i 0
```

##### Visualize (Train, Normal Index 0)

```bash
python kitti_object_vis/kitti_object.py --show_lidar_with_depth --const_box --vis -d KITTI_smaller -i 0
```

These can be used to compare the lidar point cloud and the stereo point cloud, and in case that the stereo PCL doesn't correspond well to the lidar, further tuned. I tried replicating the sparsity and scanlineness of the lidar PCL when generating the stereo, and the results were satisfactory.

## Utility Scripts and Docker

### Dockerfile

The Docker container is based on the MMDetection3D project but includes many fixes and updates to ensure it remains up-to-date and functional. It installs all necessary dependencies, including PyTorch, MMEngine, MMCV, MMDetection, and MMDetection3D. Additionally, it includes tools for deployment and integration with Google Cloud Storage.

### Shell into MMDetection3D Container

This script builds and runs a Docker container with GPU support and volume mapping for the project. Use the `--build` argument to build the container before running it. This is most useful when experimenting with mmdet3d.

```bash
# Build and run the container
./shell_into_mmdet3d.sh --build

# Run the container without building
./shell_into_mmdet3d.sh
```

### Run TorchX Training

This script runs the training process using TorchX on a Kubernetes cluster. You need to specify the training target (`lidar`, `stereo`, or `smoke`).

```bash
# Run training for lidar
./run_torchx.sh lidar

# Run training for stereo
./run_torchx.sh stereo

# Run training for smoke
./run_torchx.sh smoke
```

Currently, only `smoke` seems to run correctly. `stereo` and `lidar` both crash for unknown reasons, and this has yet to be debugged.
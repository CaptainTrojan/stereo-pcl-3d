#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <train_target>"
    echo "train_target must be one of: lidar, stereo, smoke"
    exit 1
fi

TRAIN_TARGET=$1

if [[ "$TRAIN_TARGET" != "lidar" && "$TRAIN_TARGET" != "stereo" && "$TRAIN_TARGET" != "smoke" ]]; then
    echo "Invalid train_target: $TRAIN_TARGET"
    echo "train_target must be one of: lidar, stereo, smoke"
    exit 1
fi

torchx run -s kubernetes dist.ddp \
        --name kitti-stereo-pcl \
        -j 1x1 \
        --env TRAIN_TARGET=$TRAIN_TARGET \
        -h gpu_l4 \
        --script entrypoint.py
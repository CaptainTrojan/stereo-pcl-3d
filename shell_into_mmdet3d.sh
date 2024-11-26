#!/bin/bash

# Check if "--build" argument is provided
if [[ "$1" == "--build" ]]; then
    docker buildx build -t mmdet3d-container .
    if [[ $? -ne 0 ]]; then
        echo "Build failed. Exiting."
        exit 1
    fi
fi

# Run the container with GPU support
docker run --gpus all -it --rm --shm-size=8g mmdet3d-container /bin/bash

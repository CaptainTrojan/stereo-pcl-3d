#!/bin/bash

# Check if "--build" argument is provided
if [[ "$1" == "--build" ]]; then
    docker buildx build -t mmdet3d-container .
    if [[ $? -ne 0 ]]; then
        echo "Build failed. Exiting."
        exit 1
    fi
fi

# Allow Docker to access the host's X11 server
xhost +local:docker

# Run the container with GPU support and X11 mapping
docker run --gpus all -it --rm \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/dev/dri:/dev/dri" \
    mmdet3d-container /bin/bash

# Revoke X11 access after the container stops
xhost -local:docker

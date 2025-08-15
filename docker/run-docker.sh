#!/bin/bash
# run-yocto.sh - build & run Yocto Docker container

set -e

# Name of the Docker image
IMAGE_NAME="yocto_container"

# Directory containing the Yocto project (default: current folder)
YOCTO_DIR="$(pwd)"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image '$IMAGE_NAME' not found. Building..."
    docker build -t $IMAGE_NAME .
else
    echo "Docker image '$IMAGE_NAME' already exists."
fi

# Run the container with Yocto project mounted
docker run --rm -it \
    -v "$YOCTO_DIR":/work \
    -w /work \
    $IMAGE_NAME /bin/bash


#!/bin/bash

set -e

IMAGE_NAME="my-yocto.3"
YOCTO_DIR="/home/zied/techleefYocto_Project/Yocto_project"        
KAS_CONFIG="project.yml"  
YOCTO_DL_DIR="/home/zied/yocto/build/downloads"
YOCTO_CACHE_DIR="/home/zied/yocto/build/sstate-cache" 
# Check if Docker image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image '$IMAGE_NAME' not found. Building..."
    docker build -t $IMAGE_NAME .
else
    echo "Docker image '$IMAGE_NAME' already exists."
fi

CONTAINER_NAME="yocto-buildenv"
# If container exists, start it
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Starting existing container..."
    docker start -ai $CONTAINER_NAME
else
# Run container
docker run -it \
    --name $CONTAINER_NAME \
    -v "$YOCTO_DIR":/work \
    -v "$YOCTO_DL_DIR":/work/build/downloads \
    -v "$YOCTO_CACHE_DIR":/work/build/sstate-cache \
    -w /work \
    -u yocto \
    $IMAGE_NAME /bin/bash
fi

    
#    bash -c '
# Install kas for yocto user if not already installed
#export PATH="$HOME/.local/bin:$PATH"

#if ! command -v kas &> /dev/null; then
#    echo "Installing kas..."
#    python3 -m pip install --user --no-cache-dir kas
#fi

# Ensure local bin is in PATH
#export PATH="$HOME/.local/bin:$PATH"

# Test kas installation
#echo "Testing kas installation:"
#kas --version

# Keep interactive shell open
#echo "Entering interactive shell. Your project is mounted at /work"
#exec /bin/bash
#'


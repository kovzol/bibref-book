#!/bin/bash
# This script runs TeXmacs in a Docker virtualization while showing the bibref book interactively.

set -e

echo "Checking prerequisites..."
if command -v apt >/dev/null; then
  echo "This is an apt based system, good."
  dpkg -s docker.io >/dev/null 2>&1 && echo "Docker is available, good." || {
    echo "Docker is missing, let's install it..."
    sudo apt install docker.io
    }
else
  echo "This system is not based on apt, sorry."
  exit 1
fi

echo "Building the image..."
IMAGE_TAG=bibref-book
sudo docker build -t $IMAGE_TAG .

echo "Setting X11 permissions..."
xhost +local:docker

echo "Running the image..."
sudo docker run -it -e DISPLAY=$DISPLAY -e LANG=$LANG -v /tmp/.X11-unix:/tmp/.X11-unix $IMAGE_TAG

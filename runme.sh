#!/bin/bash
# This script runs TeXmacs in a Docker virtualization while showing the bibref book interactively.

set -e

DOCKER="docker-unset"

echo "Checking prerequisites..."
if command -v apt >/dev/null; then
  echo "This is an apt based system, good."
  dpkg -s docker.io >/dev/null 2>&1 && echo "Docker is available, good." || {
    echo "Docker is missing, let's install it..."
    sudo apt install docker.io
    }
  DOCKER="sudo docker"
else
  if command -v pacman >/dev/null; then
    echo "This is a pacman based system, good."
    pacman -Q docker >/dev/null 2>&1 && echo "Docker is available, good." || {
      echo "Docker is missing, let's install it..."
      sudo pacman -S docker
      echo "Adding group docker..."
      sudo groupadd docker
      echo "Adding current user to group docker..."
      sudo usermod -aG docker $USER
      }
    test -r /var/run/docker.sock || {
      echo "Creating /var/run/docker.sock..."
      sudo touch /var/run/docker.sock
      sudo chown $USER /var/run/docker.sock
      }
   echo "Starting docker..."
   systemctl start docker
   DOCKER=docker
   pacman -Q xorg-xhost >/dev/null 2>&1 && echo "xhost is available, fine." || {
     sudo pacman -S xorg-xhost
     }
  else
   echo "This system is not based on neither apt nor pacman, sorry."
   exit 1
  fi
fi

echo "Building the image..."
IMAGE_TAG=bibref-book
$DOCKER build -t $IMAGE_TAG .

echo "Setting X11 permissions..."
xhost +local:docker

echo "Running the image..."
$DOCKER run -it -e DISPLAY=$DISPLAY -e LANG=$LANG -v /tmp/.X11-unix:/tmp/.X11-unix $IMAGE_TAG

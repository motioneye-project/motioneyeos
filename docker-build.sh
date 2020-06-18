#!/bin/bash
IMAGE_NAME=motioneyeos-builder
CONTAINER_NAME=""
SHOW_USAGE=false

while true
do
  case "$1" in
    -i|--image) if [ $# -lt 2 ]; then SHOW_USAGE=true; else IMAGE_NAME=$2; shift; fi; shift;;
    -c|--container) if [ $# -lt 2 ]; then SHOW_USAGE=true; else CONTAINER_NAME=$2; shift; fi; shift;;
    -?|-h|--help) SHOW_USAGE="true"; shift;;
    *) break;;
  esac
done

if [ "${SHOW_USAGE}" = "true" ]; then
  echo "Usage: $0 [-i|--image <image-tag>]  [-c|--container <container-name>] <args>"
  echo "    -i | --image: Docker image to use (default image name is 'motioneyeos-builder')"
  echo "    -c | --container: Name for Docker container (defaults to image name with a randome integer appended"
  echo "    causes a docker image to build motioneyeos in a docker container"
  exit 1
fi

if [ "${CONTAINER_NAME}" = "" ]; then
  CONTAINER_NAME="${IMAGE_NAME}-${RANDOM}"
fi

docker run --rm --name "${CONTAINER_NAME}" --mount type=bind,src=${PWD},target=/build -it "${IMAGE_NAME}" ./build.sh "$@"

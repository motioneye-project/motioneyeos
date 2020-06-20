#!/bin/bash

IMAGE_NAME=motioneyeos-builder
SHOW_USAGE=false

while true
do
  case "$1" in
    -i|--image) if [ $# -lt 2 ]; then SHOW_USAGE=true; else IMAGE_NAME=$2; shift; fi; shift;;
    --image) if [ $# -lt 2 ]; then SHOW_USAGE=true; else IMAGE_NAME=$2; shift; fi; shift;;
    -?|-h|--help) SHOW_USAGE="true"; shift;;
    *) break;;
  esac
done

if [ "${SHOW_USAGE}" = "true" ]; then
  echo "Usage: $0 [-i|--image <image-tag>]"
  echo "    builds a docker image based on Ubuntu 18.04 for building motioneyeos"
  echo "    default image name is 'motioneyeos-builder'"
  exit 1
fi

docker build -t "${IMAGE_NAME}" .


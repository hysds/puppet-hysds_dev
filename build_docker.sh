#!/bin/bash
if [ "$#" -ne 1 ]; then
  echo "Enter tag as arg: $0 <tag>"
  echo "e.g.: $0 20170620"
  echo "e.g.: $0 latest"
  exit 1
fi
TAG=$1

# build dev images
docker build --rm --force-rm -t hysds/dev:${TAG} -f docker/Dockerfile .
docker build --rm --force-rm -t hysds/cuda-dev:${TAG} -f docker/Dockerfile.cuda .
